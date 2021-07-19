//
//  BoardModelTests.swift
//  Game2048Tests
//
//  Created by Avinash on 19/07/21.
//

import XCTest
@testable import Game2048

class BoardModelTests: XCTestCase {
    var boardModel: BoardModel!
        
    override func setUpWithError() throws {
        super.setUp()
        
        boardModel = BoardModel(dimension: 4)
        let boardView = UIView()
        _ = GameViewModel(view: boardView, board: boardModel)
    }

    override func tearDownWithError() throws {
        boardModel = nil
    }
    
    func testGetSquare() {
        // Arrange
        let position = (row: 1, col: 2)
                
        // Assert
        guard let square = boardModel.getSquare(for: position) else {
            XCTFail()
            return
        }
        XCTAssertEqual(position.row, square.position.row)
        XCTAssertEqual(position.col, square.position.col)
    }
    
    func testLeftSquare() {
        // Arrange
        let position = (row: 1, col: 2)
        boardModel.curPosition = position
                
        // Assert
        guard let square = boardModel.leftSquare else {
            XCTFail()
            return
        }
        XCTAssertEqual(position.row, square.position.row)
        XCTAssertEqual(position.col - 1, square.position.col)
    }
    
    func testRightSquare() {
        // Arrange
        let position = (row: 1, col: 2)
        boardModel.curPosition = position
                
        // Assert
        guard let square = boardModel.rightSquare else {
            XCTFail()
            return
        }
        XCTAssertEqual(position.row, square.position.row)
        XCTAssertEqual(position.col + 1, square.position.col)
    }
    
    func testUpSquare() {
        // Arrange
        let position = (row: 1, col: 2)
        boardModel.curPosition = position
                
        // Assert
        guard let square = boardModel.upSquare else {
            XCTFail()
            return
        }
        XCTAssertEqual(position.row - 1, square.position.row)
        XCTAssertEqual(position.col, square.position.col)
    }
    
    func testDownSquare() {
        // Arrange
        let position = (row: 1, col: 2)
        boardModel.curPosition = position
                
        // Assert
        guard let square = boardModel.downSquare else {
            XCTFail()
            return
        }
        XCTAssertEqual(position.row + 1, square.position.row)
        XCTAssertEqual(position.col, square.position.col)
    }
    
    func testResetValues() {
        // Act
        boardModel.resetValues()
        
        for row in 0..<boardModel.dimension {
            for col in 0..<boardModel.dimension {
                let square = boardModel.squaresList[row][col]
                
                XCTAssertEqual(square.isMerging, false)
                XCTAssertEqual(square.isRemoving, false)
                XCTAssertNil(square.adjacentSquare)
                XCTAssertEqual(square.steps, 0)
                XCTAssertEqual(square.value, 0)
            }
        }
    }
    
    func testGetBoardState() {
        // Arrange
        boardModel.resetValues()
        let square = boardModel.getSquare(for: (row: 0, col: 0))
        
        // ACT
        square?.value = 4
        let state1 = boardModel.getBoardState()
        
        square?.value = 8
        let state2 = boardModel.getBoardState()
        
        square?.value = 4
        let state3 = boardModel.getBoardState()
        
        // Assert
        XCTAssertNotEqual(state1, state2)
        XCTAssertEqual(state1, state3)
    }
    
    func testBoardHasChanges() {
        // Arrange
        let square = boardModel.getSquare(for: (row: 1, col: 1))
        square?.value = 0
        
        // Act
        let hasChanges = boardModel.boardHasChange()

        // Assert
        XCTAssertEqual(hasChanges, true)
    }
}
