//
//  Ball.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 16/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Models the ball launched by the user.
class Ball: PhysicsBody {

    var mass: Double = 1.0
    var velocity: Vector
    var forces = [Vector]()
    var position: Vector
    var shape: Shape
    let radius: Double

    /// Returns the bounding box of the ball.
    func computeBoundingBox() -> BoundingBox {
        let min = Vector(x: self.position.x - radius, y: self.position.y - radius)
        let max = Vector(x: self.position.x + radius, y: self.position.y + radius)
        return BoundingBox(min: min, max: max)
    }

    init?(position: Vector, velocity: Vector, radius: Double) {
        guard radius > 0 else {
            return nil
        }

        self.radius = radius
        self.position = position
        self.velocity = velocity
        self.shape = .circle(radius)
    }
}
