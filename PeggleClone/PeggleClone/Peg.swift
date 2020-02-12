//
//  Peg.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 25/1/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Represents a peg in the game Peggle.
class Peg: Hashable {

    let color: Color
    let radius: Double
    let center: Point
    private(set) var isHighlighted: Bool = false

    /// Initializes a `Peg` with the specified properties.
    /// Initializes a `nil` object if the `radius` is negative.
    init?(center: Point, radius: Double, color: Color) {
        guard radius > 0 else {
            return nil
        }

        self.center = center
        self.radius = radius
        self.color = color
    }

    func highlight() {
        self.isHighlighted = true
    }

    func dehighlight() {
        self.isHighlighted = false
    }

    /// Returns `true` if the entered `Point` is contained inside the space
    /// occupied by the peg.
    func containsPoint(point: Point) -> Bool {
        radius > center.calculateDistanceTo(point: point)
    }

    /// Returns a copy of the peg.
    func copy() -> Peg {
        Peg(center: self.center, radius: self.radius, color: self.color)!
    }

    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.color == rhs.color
            && lhs.center == rhs.center
            && lhs.radius == rhs.radius
            && lhs.isHighlighted == rhs.isHighlighted
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.color)
        hasher.combine(self.radius)
        hasher.combine(self.center)
        hasher.combine(self.isHighlighted)
    }

}
