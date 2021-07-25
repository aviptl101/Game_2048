//
//  GameViewModelTests.swift
//  Game2048Tests
//
//  Created by Avinash on 19/07/21.
//

import XCTest
@testable import Game2048

class GameViewModelTests: XCTestCase {
    var gameVM: GameViewModel!
    var boardView: UIView!
    
    override func setUpWithError() throws {
        super.setUp()

        let boardModel = BoardModel(dimension: 4)
        boardView = UIView()
        gameVM = GameViewModel(view: boardView, board: boardModel)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddRandomTile() {
        // Arrange
        let numberOfTiles = gameVM.boardModel.tilesCount
        
        // ACT
        gameVM.addRandomTile()
        
        // Assert
        XCTAssertEqual(numberOfTiles + 1, gameVM.boardModel.tilesCount)
    }
    
    func testSetTestTiles() {
        // Arrange
        var positions = [(0, 0), (0, 1), (0, 2), (0, 3)]
        positions.append(contentsOf: [(1, 0), (1, 1), (1, 2), (1, 3)])
        positions.append(contentsOf: [(2, 0), (2, 1), (2, 2), (2, 3)])
        positions.append(contentsOf: [(3, 0), (3, 1), (3, 2), (3, 3)])

        var values = [2, 4, 2, 1024]
        values.append(contentsOf: [4, 2, 4, 2])
        values.append(contentsOf: [2, 4, 2, 4])
        values.append(contentsOf: [4, 2, 4, 2])
        
        // ACT
        gameVM.setTestTiles(positions: positions, values: values)
        
        // Assert
        XCTAssertEqual(1024, gameVM.boardModel.squaresList[0][3].value)
    }

    func testCheckGameOverStatus() {
        // Arrange
        var positions = [(0, 0), (0, 1), (0, 2), (0, 3)]
        positions.append(contentsOf: [(1, 0), (1, 1), (1, 2), (1, 3)])
        positions.append(contentsOf: [(2, 0), (2, 1), (2, 2), (2, 3)])
        positions.append(contentsOf: [(3, 0), (3, 1), (3, 2), (3, 3)])

        var values = [2, 4, 2, 4]
        values.append(contentsOf: [4, 2, 4, 2])
        values.append(contentsOf: [2, 4, 2, 4])
        values.append(contentsOf: [4, 2, 4, 2])
        gameVM.setTestTiles(positions: positions, values: values)
        
        // ACT
        gameVM.checkGameOverStatus()
        
        // Assert
        XCTAssertEqual(gameVM.isGameOver, true)
    }
}
