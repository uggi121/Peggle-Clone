//
//  GameBoardDimensionsTests.swift
//  PeggleCloneTests
//
//  Created by Sudharshan Madhavan on 17/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import XCTest
@testable import PeggleClone

class GameBoardDimensionsTests: XCTestCase {

    func testInit_validInputs() {
        _ = GameBoardDimensions(xMin: 0, xMax: 1, yMin: 0, yMax: 1, minimumSize: 0.5)
    }

    func testInit_widthLessThanMinimumSize() {
        let dimensions = GameBoardDimensions(xMin: 0, xMax: 0.5, yMin: 1, yMax: 2, minimumSize: 1)
        XCTAssertNil(dimensions)
    }

    func testInit_heightLessThanMinimumSize() {
        let dimensions = GameBoardDimensions(xMin: 0, xMax: 1.5, yMin: 1, yMax: 2, minimumSize: 1.2)
        XCTAssertNil(dimensions)
    }

    func testInit_minimumSizeIsNegative() {
        let dimensions = GameBoardDimensions(xMin: 0, xMax: 0.5, yMin: 1, yMax: 2, minimumSize: -1)
        XCTAssertNil(dimensions)
    }

    func testInit_minimumSizeIsZero() {
        let dimensions = GameBoardDimensions(xMin: 0, xMax: 0.5, yMin: 1, yMax: 2, minimumSize: -0)
        XCTAssertNil(dimensions)
    }

    func testInit_negativeWidth() {
        let dimensions = GameBoardDimensions(xMin: 1, xMax: 0.5, yMin: 1, yMax: 2, minimumSize: 0.1)
        XCTAssertNil(dimensions)
    }

    func testInit_negativeHeight() {
        let dimensions = GameBoardDimensions(xMin: 0, xMax: 0.5, yMin: 10, yMax: 2, minimumSize: 0.1)
        XCTAssertNil(dimensions)
    }

    func testIsPegWithinBounds() {
        let dimensions = GameBoardDimensions(xMin: -2, xMax: 2, yMin: -2, yMax: 2, minimumSize: 1)
        XCTAssertTrue(dimensions!.isPegWithinBounds(
            center: Point(x: 0, y: 0), radius: 1))
    }

    func testIsPegWithinBounds_pegCenterOutsideBoard() {
        let dimensions = GameBoardDimensions(xMin: -2, xMax: 2, yMin: -2, yMax: 2, minimumSize: 1)
        XCTAssertFalse(dimensions!.isPegWithinBounds(
            center: Point(x: 3, y: 3), radius: 1))
    }

    func testIsPegWithinBounds_pegBoundaryOutsideBoard() {
        let dimensions = GameBoardDimensions(xMin: -2, xMax: 2, yMin: -2, yMax: 2, minimumSize: 1)
        XCTAssertFalse(dimensions!.isPegWithinBounds(
            center: Point(x: 0, y: 0), radius: 3))
    }

}
