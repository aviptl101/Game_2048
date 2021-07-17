//
//  TileView.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

class TileView: UIView {
    var points = 2
    
    private let valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = Constants.Fonts.tileFont
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        setupTile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTile() {
        layer.backgroundColor = UIColor.orange.cgColor
        layer.cornerRadius = 5
        
        valueLabel.text = String(points)
        valueLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(valueLabel)
    }
}
