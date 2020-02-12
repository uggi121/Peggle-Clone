//
//  Point.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 25/1/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Represents a point in a 2-D Euclidean space.
struct Point: Hashable {
    var x: Double
    var y: Double

    /// Initializes a point at the co-ordinates (x, y)
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// Calculates the euclidean distance to the input `Point`.
    /// - Parameters:
    ///     - point: `Point`
    /// - Returns: The distance between the `Point`s.
    func calculateDistanceTo(point: Point) -> Double {
        let x2 = point.x
        let y2 = point.y

        let deltaX = x2 - x
        let deltaY = y2 - y

        let squareDistance = (deltaX * deltaX) + (deltaY * deltaY)
        let distance = sqrt(squareDistance)

        return distance
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
