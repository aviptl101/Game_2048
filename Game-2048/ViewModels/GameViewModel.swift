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
    
    private func setupSquareViews() {
        let width = boardView.frame.width
        let maxTiles = CGFloat(dimension)
        let padding: CGFloat = 10
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
    }
    
    func swipeAction(for direction: SwipeDirection) {
        // TODO: make action calls
    }
}
