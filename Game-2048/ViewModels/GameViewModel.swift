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
                self.isSwipeLocked = false
                self.boardModel.resetValues()
                NotificationCenter.default.post(name: .updateBoard, object: nil)
                self.boardModel.displaySquareValues()
            }
        }
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
    func evaluateWithAdjacentSquare(square: SquareView?) {
        guard let curSquare = boardModel.curSquare else { return }
        guard let adjSquare = square else { return }
        
        var steps = 0
        steps = adjSquare.steps
        if adjSquare.value == 0 {
            steps += 1
        }
        if boardModel.posValue > 0 && boardModel.posValue == adjSquare.value && !adjSquare.isMerging {
            steps += 1
            curSquare.isMerging = true
            adjSquare.isRemoving = true
        }
        curSquare.steps = steps
    }
    
    func setTestTiles() {
        var positions = [(0, 0), (0, 1), (0, 2), (0, 3)]
        
        var values = [2, 2, 2, 2]

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
