//
//  BoardModel.swift
//  Game-2048
//
//  Created by Avinash on 18/07/21.
//

import Foundation

/// BoardModel holds and maintains all the board squares and their data and represents Game state and Board status
/// Squares are place holder for Tiles and represents corresponding Tile's value
class BoardModel {
    var dimension = 4
    // Set curPosition to get values or adjacent squares of a square at particular position
    var curPosition = (row: 0, col: 0)
    var squaresList = [[SquareView]]()

    var posValue: Int {
        return squaresList[curPosition.row ][curPosition.col].value
    }
    
    var curSquare: SquareView? {
        return squaresList[curPosition.row][curPosition.col]
    }
    
    init(dimension: Int) {
        self.dimension = dimension
        squaresList = [[SquareView]](repeating: [SquareView](repeating: SquareView(), count: dimension), count: dimension)
    }
    
    func getSquare(for position: (row: Int, col: Int)) -> SquareView? {
        if position.row >= 0 && position.row < dimension && position.col >= 0 && position.col < dimension {
            return squaresList[position.row][position.col]
        } else {
            return nil
        }
    }
    
    var leftSquare: SquareView? {
        if curPosition.col > 0 {
            return squaresList[curPosition.row][curPosition.col - 1]
        } else {
            return nil
        }
    }
    
    var rightSquare: SquareView? {
        if curPosition.col < dimension - 1 {
            return squaresList[curPosition.row][curPosition.col + 1]
        } else {
            return nil
        }
    }
    
    var upSquare: SquareView? {
        if curPosition.row > 0 {
            return squaresList[curPosition.row - 1][curPosition.col]
        } else {
            return nil
        }
    }
    
    var downSquare: SquareView? {
        if curPosition.row < dimension - 1 {
            return squaresList[curPosition.row + 1][curPosition.col]
        } else {
            return nil
        }
    }
    
    func displaySquareValues() {
        print("\n")
        for row in 0..<dimension {
            let square1 = squaresList[row][0]
            let square2 = squaresList[row][1]
            let square3 = squaresList[row][2]
            let square4 = squaresList[row][3]

            print("\(square1.steps) \(square2.steps) \(square3.steps) \(square4.steps)")
        }
        print("\n")
        for row in 0..<dimension {
            let square1 = squaresList[row][0]
            let square2 = squaresList[row][1]
            let square3 = squaresList[row][2]
            let square4 = squaresList[row][3]

            print("\(square1.value) \(square2.value) \(square3.value) \(square4.value)")
        }
    }
    
    func resetValues() {
        for row in 0..<dimension {
            for col in 0..<dimension {
                let square = squaresList[row][col]
                square.steps = 0
                square.value = 0
            }
        }
    }
}
