//
//  TileView.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

class TileView: UIView {
    weak var gameVM: GameViewModel?
    var position = (row: -1, col: -1)
    var value = 2 {
        didSet {
            updateUI()
        }
    }
    
    private let valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont.tile.x4
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
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
    
    private func setupTile() {
        NotificationCenter.default.addObserver(self, selector: #selector(swipeAction), name: .swipeAction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBoardValue), name: .updateBoard, object: nil)
        
        layer.backgroundColor = UIColor.orange.cgColor
        layer.cornerRadius = 5
        
        valueLabel.text = String(value)
        valueLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(valueLabel)
    }
    
    @objc func updateBoardValue() {
        guard let curSquare = gameVM?.boardModel.getSquare(for: position) else { return }
        curSquare.value = value
    }

    @objc func swipeAction() {
        guard let curSquare = gameVM?.boardModel.getSquare(for: position) else { return }

        guard let nextSquare = gameVM?.getNextSquare(position: position) else {
            if curSquare.isRemoving {
                self.removeAction()
            }
            return
        }
        moveTile(to: nextSquare)
    }
    
    func moveTile(to square: SquareView) {
        guard let curSquare = gameVM?.boardModel.getSquare(for: position) else { return }
        
        UIView.animate(withDuration: Constants.tileMoveDuration) {
            self.center = square.center
        } completion: { (status) in
            self.position = square.position
            if curSquare.isMerging {
                self.mergeAction()
            } else if curSquare.isRemoving {
                self.removeAction()
            }
        }
    }
    
    func mergeAction() {
        self.value *= 2
        self.gameVM?.score += self.value
        
        // ZoomIn-Out animation
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
        }) }
    }
    
    func removeAction() {
        gameVM?.boardModel.tilesCount -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.tileMoveDuration) {
            self.removeFromSuperview()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.valueLabel.text = String(self.value)
            if self.value > 10 && self.value < 99 {
                self.valueLabel.font = UIFont.tile.x3
            } else if self.value > 99 && self.value < 1000 {
                self.valueLabel.font = UIFont.tile.x2
            } else if self.value > 999 {
                self.valueLabel.font = UIFont.tile.x
            }
            
            if self.value <= 64 {
                self.valueLabel.textColor = .square
            } else {
                self.valueLabel.textColor = .white
            }
            
            switch self.value {
            case 2:
                self.backgroundColor = .s2
            case 4:
                self.backgroundColor = .s4
            case 8:
                self.backgroundColor = .s8
            case 16:
                self.backgroundColor = .s16
            case 32:
                self.backgroundColor = .s32
            case 64:
                self.backgroundColor = .s64
            case 128:
                self.backgroundColor = .s128
            case 256:
                self.backgroundColor = .s256
            case 512:
                self.backgroundColor = .s512
            default:
                self.backgroundColor = .s128
            }
        }
    }
    
    deinit {
        print("deleted \(value)")
        NotificationCenter.default.removeObserver(self, name: Notification.Name.swipeAction, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.updateBoard, object: nil)
    }
}
