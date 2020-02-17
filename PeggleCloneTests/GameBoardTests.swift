//
//  GameBoardTests.swift
//  PeggleCloneTests
//
//  Created by Sudharshan Madhavan on 17/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import XCTest
@testable import PeggleClone

class GameBoardTests: XCTestCase {

    let dimensions = GameBoardDimensions(xMin: 0, xMax: 100, yMin: 0, yMax: 100, minimumSize: 10)
    private var gameBoard = GameBoard(
        dimensions: GameBoardDimensions(xMin: 0, xMax: 100, yMin: 0, yMax: 100, minimumSize: 10)!)
    let invalidPegOne = Peg(center: Point(x: 0, y: 0), radius: 20, color: .blue)
    let invalidPegTwo = Peg(center: Point(x: -5, y: 20), radius: 15, color: .blue)
    let invalidPegThree = Peg(center: Point(x: 50, y: 50), radius: 50, color: .orange)

    let validPegOne = Peg(center: Point(x: 25, y: 25), radius: 10, color: .orange)
    let validPegTwo = Peg(center: Point(x: 50, y: 50), radius: 32, color: .orange)
    let validPegThree = Peg(center: Point(x: 50, y: 30), radius: 5, color: .blue)
    let validPegFour = Peg(center: Point(x: 15, y: 25), radius: 5, color: .orange)

    override func setUp() {
        super.setUp()
        gameBoard = GameBoard(dimensions: dimensions!)
    }

    func testAddPeg_validLocations() {
        let firstAdded = gameBoard.addPeg(peg: validPegOne!)
        let secondAdded = gameBoard.addPeg(peg: validPegThree!)
        XCTAssertTrue(firstAdded && secondAdded)
    }

    func testAddPeg_outOfBounds() {
        let addedPeg = gameBoard.addPeg(peg: invalidPegTwo!)
        XCTAssertFalse(addedPeg)
    }

    func testAddPeg_onBoundary() {
        let addedPegOne = gameBoard.addPeg(peg: invalidPegOne!)
        let addedPegTwo = gameBoard.addPeg(peg: invalidPegThree!)
        XCTAssertFalse(addedPegOne && addedPegTwo)
    }

    func testAddPeg_secondOverlapsFirst() {
        let firstAdded = gameBoard.addPeg(peg: validPegOne!)
        let secondAdded = gameBoard.addPeg(peg: validPegTwo!)
        XCTAssertTrue(firstAdded)
        XCTAssertFalse(secondAdded)
    }

    func testRemovePeg_validPointNotCenterOfPeg() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        let point = gameBoard.removePeg(at: Point(x: 13, y: 24))
        XCTAssertEqual(point!, Point(x: 15, y: 25))
    }

    func testRemovePeg_validPointCenterOfPeg() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        let point = gameBoard.removePeg(at: Point(x: 15, y: 25))
        XCTAssertEqual(point!, Point(x: 15, y: 25))
    }

    func testRemovePeg_invalidPoint() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        let point = gameBoard.removePeg(at: Point(x: 10, y: 30))
        XCTAssertNil(point)
    }

    func testRemovePeg_pointOnBoundary() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        let point = gameBoard.removePeg(at: Point(x: 15, y: 30))
        XCTAssertNil(point)
    }

    func testRemovePeg_addRemoveAndRemove() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        let point = gameBoard.removePeg(at: Point(x: 15, y: 25))
        let secondPoint = gameBoard.removePeg(at: point!)
        XCTAssertNil(secondPoint)
    }

    func testRemovePeg_addRemoveAdd() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        _ = gameBoard.removePeg(at: Point(x: 15, y: 25))
        let added = gameBoard.addPeg(peg: validPegFour!)
        XCTAssertTrue(added)
    }

    func testContainsPeg_valid() {
        _ = gameBoard.addPeg(peg: validPegOne!)
        XCTAssertTrue(gameBoard.containsPeg(peg: validPegOne!))
    }

    func testContainsPeg_addRemovePeg() {
        _ = gameBoard.addPeg(peg: validPegFour!)
        XCTAssertTrue(gameBoard.containsPeg(peg: validPegFour!))

        _ = gameBoard.removePeg(at: Point(x: 15, y: 25))
        XCTAssertFalse(gameBoard.containsPeg(peg: validPegFour!))
    }

    func testContainsPeg_invalid() {
        XCTAssertFalse(gameBoard.containsPeg(peg: invalidPegTwo!))
    }

    func testGetPegs_empty() {
        let pegs = gameBoard.getPegs()
        XCTAssertTrue(pegs.isEmpty)
    }

    func testGetPegs_nonEmpty() {
        _ = gameBoard.addPeg(peg: validPegOne!)
        _ = gameBoard.addPeg(peg: validPegThree!)
        let pegs = gameBoard.getPegs()
        let expectedPegs = Set<Peg>(arrayLiteral: validPegOne!, validPegThree!)
        XCTAssertEqual(pegs, expectedPegs)
    }

    func testGetPegs_addRemove() {
        _ = gameBoard.addPeg(peg: validPegThree!)
        _ = gameBoard.removePeg(at: Point(x: 50, y: 30))
        XCTAssertTrue(gameBoard.getPegs().isEmpty)
    }

    func testReset() {
        _ = gameBoard.addPeg(peg: validPegOne!)
        _ = gameBoard.addPeg(peg: validPegThree!)
        gameBoard.reset()
        let pegs = gameBoard.getPegs()
        XCTAssertTrue(pegs.isEmpty)
    }

}
