//
//  GameViewModel.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

enum SwipeDirection {
    case left
    case right
    case up
    case down
}

class GameViewModel {
    weak var boardView: UIView!
    var boardModel: BoardModel!
    var swipeDirection = SwipeDirection.left
    var isSwipeLocked = false
    var dimension = 4
    
    init(view: UIView, board: BoardModel) {
        self.boardView = view
        self.boardModel = board
        self.dimension = board.dimension
        setupSquareViews()
    }
    
    /// Placing squares in boardView according to rows and columns for DxD matrix form
    private func setupSquareViews() {
        let width = boardView.frame.width
        let maxTiles = CGFloat(dimension)
        let padding: CGFloat = 10
        // calculating Tile width according to numberOfTiles and width available
        let tileWidth: CGFloat = (width - ((maxTiles + 1) * padding)) / maxTiles
        
        var x_pos = padding
        var y_pos = padding
        
        for row in 0..<dimension {
            x_pos = padding
            for col in 0..<dimension {
                let square = SquareView(frame: CGRect(x: x_pos, y: y_pos, width: tileWidth, height: tileWidth))
                square.position = (row: row, col: col)
                boardModel.squaresList[row][col] = square
                boardView.addSubview(square)
                x_pos += padding + tileWidth
            }
            y_pos += padding + tileWidth
        }
//        addRandomTile()
//        addRandomTile()
        self.setTestTiles()
    }
    
    func swipeAction(for direction: SwipeDirection) {
        if !isSwipeLocked {
            // locking swipeAction briefly for Tiles animation time
            isSwipeLocked = true
            swipeDirection = direction
            
            switch direction {
            case .left:
                calculateLeftSwipe()
            case .right:
                calculateRightSwipe()
            case .up:
                calculateUpSwipe()
            case .down:
                calculateDownSwipe()
            }
            //boardModel.displaySquareValues()
            NotificationCenter.default.post(name: .swipeAction, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.swipeActionCompletion()
            }
        }
    }
    
    /// On swipeAction complete: board update, add new Tiles (only if Board state changed )
    func swipeActionCompletion() {
        self.isSwipeLocked = false
        let state = boardModel.getBoardState()
        self.boardModel.resetValues()
        NotificationCenter.default.post(name: .updateBoard, object: nil)
        if state != boardModel.getBoardState() {
            self.addRandomTile()
        }
        self.boardModel.displaySquareValues()
    }
    
    /// calculating steps/moves for each square with Adjacent square in Swipe direction
    func calculateLeftSwipe() {
        for row in 0..<dimension {
            for col in 1..<dimension {
                boardModel.curPosition = (row: row, col: col)
                evaluateWithAdjacentSquare(square: boardModel.leftSquare)
            }
        }
    }
    
    func calculateRightSwipe() {
        for row in 0..<dimension {
            for col in stride(from: (dimension-2), to: -1, by: -1) {
                boardModel.curPosition = (row: row, col: col)
                evaluateWithAdjacentSquare(square: boardModel.rightSquare)
            }
        }
    }
    
    func calculateUpSwipe() {
        for col in 0..<dimension {
            for row in 1..<dimension {
                boardModel.curPosition = (row: row, col: col)
                evaluateWithAdjacentSquare(square: boardModel.upSquare)
            }
        }
    }
    
    func calculateDownSwipe() {
        for col in 0..<dimension {
            for row in stride(from: (dimension-2), to: -1, by: -1) {
                boardModel.curPosition = (row: row, col: col)
                evaluateWithAdjacentSquare(square: boardModel.downSquare)
            }
        }
    }
    
    /// Evaluation logic:
    /// Evaluating square with its adjacent square in swipe direction to determine no. of steps for the current square
    /// 1. if adjacent square is empty, square's steps increase by one
    /// 2. if square and adSquare have same values, square's steps increase by one, square will Merge, adSquare will be removed
    /// 3. if adSquare is empty, evaluating with nearest square which has Tile in the direction of Swipe
    func evaluateWithAdjacentSquare(square: SquareView?) {
        guard let curSquare = boardModel.curSquare else { return }
        guard let adjSquare = square else { return }
        
        var steps = 0
        steps = adjSquare.steps
        if adjSquare.value == 0 {
            steps += 1
        }
        if boardModel.posValue == 0 {
            curSquare.adjacentSquare = adjSquare.adjacentSquare == nil ? square : square?.adjacentSquare
        } else if boardModel.posValue > 0 && adjSquare.value == 0 && boardModel.posValue == adjSquare.adjacentSquare?.value && !(adjSquare.adjacentSquare?.isMerging ?? false) {
            steps += 1
            curSquare.isMerging = true
            adjSquare.adjacentSquare?.isRemoving = true
        }
        if boardModel.posValue > 0 && boardModel.posValue == adjSquare.value && !adjSquare.isMerging {
            steps += 1
            curSquare.isMerging = true
            adjSquare.isRemoving = true
        }
        curSquare.steps = steps
    }
    
    func getNextSquare(position: (row: Int, col: Int)) -> SquareView? {
        boardModel.curPosition = position
        let square = boardModel.curSquare
        let steps = square?.steps ?? 0
        return getSquareFor(position: position, steps: steps)
    }
    
    /// Based on the steps calculated, returning new square for each position in the swipeDirection
    func getSquareFor(position: (row: Int, col: Int), steps: Int) -> SquareView? {
        var newPosition = (row: 0, col: 0)
        
        switch swipeDirection {
        case .left:
            if position.col == 0 { return nil }
            newPosition = (row: position.row, col: position.col - steps)
        case .right:
            if position.col + steps >= dimension { return nil }
            newPosition = (row: position.row, col: position.col + steps)
        case .up:
            if position.row == 0 { return nil }
            newPosition = (row: position.row - steps, col: position.col)
        case .down:
            if position.row + steps >= dimension { return nil }
            newPosition = (row: position.row + steps, col: position.col)
        }
        
        // Preventing from array outOfBound exceptions, returning nil for exceptions
        if ((newPosition.row * newPosition.col) >= 0) && ((newPosition.row * newPosition.col) < (dimension * dimension)) {
            let nextSquare = boardModel.squaresList[newPosition.row][newPosition.col]
            return nextSquare
        } else {
            return nil
        }
    }
    
    func addRandomTile() {
        var squaresList = boardModel.squaresList.flatMap{ $0.filter{ $0.value == 0 } }
        guard let randomSqr1 = squaresList.randomElement() else { return }
        
        squaresList.removeAll { value in
            return value == randomSqr1
        }
        
        let values = [2, 4]
        let randVal = values.randomElement()
        
        let tile = TileView(frame: randomSqr1.frame)
        tile.value = randVal ?? 2
        tile.boardVM = self
        tile.position = randomSqr1.position
        tile.updateBoardValue()
        boardView.addSubview(tile)
    }
    
    func setTestTiles() {
        var positions = [(0, 0), (0, 1), (0, 2), (0, 3)]
        positions.append(contentsOf: [(1, 0), (1, 1), (1, 2), (1, 3)])
        positions.append(contentsOf: [(2, 0), (2, 1), (2, 2), (2, 3)])
        
        var values = [2, 2, 2, 2]
        values.append(contentsOf: [4, 4, 4, 4])
        values.append(contentsOf: [8, 8, 8, 8])

        for i in 0..<positions.count {
            let pos = positions[i]
            guard let sqr = boardModel.getSquare(for: pos) else { return }
            sqr.value = values[i]

            let tile = TileView(frame: sqr.frame)
            tile.value = values[i]
            tile.boardVM = self
            tile.position = sqr.position
            tile.updateBoardValue()
            boardView.addSubview(tile)
        }
    }
}
