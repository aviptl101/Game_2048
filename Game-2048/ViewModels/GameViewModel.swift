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
    
    var boardView: UIView!
    var dimension = 4
    
    init(dimension: Int, view: UIView) {
        self.dimension = dimension
        self.boardView = view
    }
}
