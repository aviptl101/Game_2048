//
//  SquareView.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

/// SquareView is place holder for Tile and holds corresponding Tile's value
/// SquareViews are used to calculate Tile's moves and Tile's actions like getting Merged Or Removed
class SquareView: UIView {
    var position = (row: -1, col: -1)
    var value = 0
    // Number of steps respective Tile will move after swipeAction
    var steps = 0
    var isMerging = false
    var isRemoving = false
    // reference to the nearest square which is having Tile in the direction of swipe
    var adjacentSquare: SquareView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        layer.backgroundColor = UIColor.square.cgColor
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
