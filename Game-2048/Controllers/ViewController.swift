//
//  ViewController.swift
//  Game-2048
//
//  Created by Avinash on 16/07/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    var boardVM: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardVM = GameViewModel(dimension: 4, view: boardView)
    }
}

