//
//  ViewController.swift
//  Game-2048
//
//  Created by Avinash on 16/07/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var bestScoreLbl: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    var gameVM: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameAction()
        setupSwipeGestures()
    }
    
    @IBAction func newGameAction() {
        self.gameOverLabel.isHidden = true
        
        let boardModel = BoardModel(dimension: 4)
        gameVM = GameViewModel(view: boardView, board: boardModel)
        gameVM.updateScore = { score in
            self.scoreLbl.text = String(score)
        }
        gameVM.gameOver = {
            self.gameOverLabel.isHidden = false
        }
        gameVM.setTestTiles()
    }
    
    func setupSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
    }
    
    @objc func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            gameVM.swipeAction(for: .left)
        case .right:
            gameVM.swipeAction(for: .right)
        case .up:
            gameVM.swipeAction(for: .up)
        case .down:
            gameVM.swipeAction(for: .down)
        default:
            gameVM.swipeAction(for: .left)
        }
    }
}

