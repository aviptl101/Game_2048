//
//  BoardModel.swift
//  Game-2048
//
//  Created by Avinash on 18/07/21.
//

import Foundation

class BoardModel {
    var dimension = 4
    var curPosition = (row: 0, col: 0)
    
    var squaresList = [[SquareView]]()

    var curSquare: SquareView? {
        return squaresList[curPosition.row][curPosition.col]
    }
    
    init(dimension: Int) {
        self.dimension = dimension
        squaresList = [[SquareView]](repeating: [SquareView](repeating: SquareView(), count: dimension), count: dimension)
    }
}
