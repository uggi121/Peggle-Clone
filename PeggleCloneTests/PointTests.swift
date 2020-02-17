//
//  PointTests.swift
//  PeggleCloneTests
//
//  Created by Sudharshan Madhavan on 17/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import XCTest
@testable import PeggleClone

class PointTests: XCTestCase {

    func testInit() {
        let point = Point(x: 3.4, y: -5.0)
        XCTAssertEqual(point.x, 3.4)
        XCTAssertEqual(point.y, -5.0)
    }

    func testCalculateDistanceTo_origin() {
        let firstPoint = Point(x: -2.5, y: 2.5)
        let secondPoint = Point(x: 0.0, y: 0.0)
        let distance = sqrt(12.5)
        XCTAssertEqual(firstPoint.calculateDistanceTo(point: secondPoint), distance)
    }

    func testCalculateDistanceTo_twoPoints() {
        let firstPoint = Point(x: -2.5, y: 2.5)
        let secondPoint = Point(x: 2.5, y: -2.5)
        let distance = sqrt(50)
        XCTAssertEqual(firstPoint.calculateDistanceTo(point: secondPoint), distance)
    }

    func testCalculateDistanceTo_reflexivity_returnsZero() {
        let point = Point(x: -2.5, y: 2.5)
        XCTAssertEqual(point.calculateDistanceTo(point: point), 0)
    }

    func testCalculateDistanceTo_symmetry_returnsEqual() {
        let firstPoint = Point(x: -2.5, y: 2.5)
        let secondPoint = Point(x: 0.0, y: 0.0)
        XCTAssertEqual(firstPoint.calculateDistanceTo(point: secondPoint),
                       secondPoint.calculateDistanceTo(point: firstPoint))
    }
}
