//
//  PegTests.swift
//  PeggleCloneTests
//
//  Created by Sudharshan Madhavan on 17/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import XCTest

@testable import PeggleClone

class PegTests: XCTestCase {

    func testInit_invalidRadius_returnsNil() {
        let peg = Peg(center: Point(x: 0.5, y: 1), radius: -2.6, color: .blue)
        XCTAssertNil(peg)
    }

    func testInit_validInputs() {
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        XCTAssertFalse(peg!.isHighlighted)
    }

    func testHighlight() {
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        peg?.highlight()
        XCTAssertTrue(peg!.isHighlighted)
    }

    func testDehighlight() {
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        peg?.dehighlight()
        XCTAssertFalse(peg!.isHighlighted)
    }

    func testContainsPoint_pointInside_returnsTrue() {
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        let point = Point(x: 1, y: 1)
        XCTAssertTrue(peg!.containsPoint(point: point))
    }

    func testContainsPoint_centerOfPeg_returnsTrue() {
        let point = Point(x: 1, y: 1)
        let peg = Peg(center: point, radius: 1.5, color: .blue)
        XCTAssertTrue(peg!.containsPoint(point: point))
    }

    func testContainsPoint_outsidePeg_returnsFalse() {
        let point = Point(x: 0, y: 10)
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        XCTAssertFalse(peg!.containsPoint(point: point))
    }

    func testContainsPoint_onPeg_returnsFalse() {
        let point = Point(x: 1, y: 0)
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.0, color: .blue)
        XCTAssertFalse(peg!.containsPoint(point: point))
    }

    func testCopy_reflexive() {
        let peg = Peg(center: Point(x: 0, y: 0), radius: 1.5, color: .blue)
        XCTAssertEqual(peg, peg!.copy())
    }

}
