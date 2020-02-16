//
//  PhysicsEngine.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 12/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Simulates the movement of bodies in the physics world.
struct PhysicsKinematicsSimulator {

    /// Simulates the motion of the input `PhysicsBody` objects for the entered amount of time.
    func simulateWorldFor(time: Double, bodies: inout [String: PhysicsBody]) {
        guard time > 0 else {
            return
        }

        for (_, var body) in bodies {
            let acceleration = calculateAcceleration(body)
            body.velocity = calculateNewVelocity(body: body, acceleration: acceleration, time: time)
            body.position = calculateNewPosition(body: body, time: time)
        }
    }

    private func calculateAcceleration(_ body: PhysicsBody) -> Vector {

        // A body with infinite mass is assumed to be unaccelerable.
        guard body.mass != Double.infinity else {
            return Vector(x: 0, y: 0)
        }

        let forces = body.forces
        let resultantForce = forces.reduce(Vector(x: 0, y: 0), { resultant, vector in
            Vector(x: resultant.x + vector.x, y: resultant.y + vector.y)
        })
        let mass = body.mass
        let acceleration = Vector(x: resultantForce.x / mass, y: resultantForce.y / mass)
        return acceleration
    }

    private func calculateNewVelocity(body: PhysicsBody, acceleration: Vector, time: Double) -> Vector {

        // A body with infinite mass is assumed to be immovable.
        guard body.mass != Double.infinity else {
            return Vector(x: 0, y: 0)
        }

        let velocity = body.velocity
        let horizontalVelocity = velocity.x + (acceleration.x * time)
        let verticalVelocity = velocity.y + (acceleration.y * time)
        return Vector(x: horizontalVelocity, y: verticalVelocity)
    }

    private func calculateNewPosition(body: PhysicsBody, time: Double) -> Vector {
        let position = body.position
        let velocity = body.velocity
        let horizontalPosition = position.x + (velocity.x * time)
        let verticalPosition = position.y + (velocity.y * time)
        return Vector(x: horizontalPosition, y: verticalPosition)
    }

}
