//
//  TileView.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

class TileView: UIView {
    weak var boardVM: GameViewModel?
    var position = (row: -1, col: -1)
    var value = 2
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(swipeAction), name: .swipeAction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBoardValue), name: .updateBoard, object: nil)
        
        layer.backgroundColor = UIColor.orange.cgColor
        layer.cornerRadius = 5
        
        valueLabel.text = String(value)
        valueLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(valueLabel)
    }
    
    @objc func updateBoardValue() {
        
    }

    @objc func swipeAction() {
        
    }
    
    func moveTile(to square: SquareView) {
        guard let curSquare = boardVM?.boardModel.getSquare(for: position) else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.center = square.center
        } completion: { (status) in
            self.position = square.position
            if curSquare.isMerging {
                self.value *= 2
            } else if curSquare.isRemoving {
                self.removeFromSuperview()
            }
        }
    }
}
