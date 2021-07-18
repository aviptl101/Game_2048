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
    var swipeDirection = SwipeDirection.left
    var isSwipeLocked = false
    
    var squaresList = [[SquareView]](repeating: [SquareView](repeating: SquareView(), count: 4), count: 4)
    
    var boardView: UIView!
    var dimension = 4
    
    init(dimension: Int, view: UIView) {
        self.dimension = dimension
        self.boardView = view
    }
    
    func setupSquareViews() {
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
                squaresList[row][col] = square
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
