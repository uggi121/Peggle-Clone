//
//  Vector.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 12/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

struct Vector {
    let x: Double
    let y: Double

    func addTo(vector: Vector) -> Vector {
        Vector(x: self.x + vector.x, y: self.y + vector.y)
    }

    func negate() -> Vector {
        Vector(x: -self.x, y: -self.y)
    }

    func dotProductWith(vector: Vector) -> Double {
        self.x * vector.x + self.y * vector.y
    }

    func subtract(vector: Vector) -> Vector {
        Vector(x: self.x - vector.x, y: self.y - vector.y)
    }

    func squareDistanceTo(vector: Vector) -> Double {
        let horizontalDistance = self.x - vector.x
        let verticalDistance = self.y - vector.y
        return horizontalDistance * horizontalDistance + verticalDistance * verticalDistance
    }

    func normalize() -> Vector {
        let magnitude = sqrt(self.x * self.x + self.y * self.y)
        return Vector(x: self.x / magnitude, y: self.y / magnitude)
    }

    func multiplyWithScalar(scalar: Double) -> Vector {
        Vector(x: self.x * scalar, y: self.y * scalar)
    }
}
