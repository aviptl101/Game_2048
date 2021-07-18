//
//  SquareView.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

class SquareView: UIView {
    
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
