//
//  PhysicsEngine.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 12/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

struct PhysicsKinematicsSimulator {

    func simulateWorldFor(time: Double, bodies: inout [String : PhysicsBody]) {
        guard time > 0 else {
            return
        }

        for (_, var body) in bodies {
            let acceleration = calculateAcceleration(body)
            body.velocity = calculateNewVelocity(body: body, acceleration: acceleration, time: time)
            body.position = calculateNewPosition(body: body, time: time)
        }
    }

    func calculateAcceleration(_ body: PhysicsBody) -> Vector {
        let forces = body.forces
        let resultantForce = forces.reduce(Vector(x: 0, y: 0), {
            resultant, vector in
            return Vector(x: resultant.x + vector.x, y: resultant.y + vector.y)
        })
        let mass = body.mass
        let acceleration = Vector(x: resultantForce.x / mass, y: resultantForce.y / mass)
        return acceleration
    }

    func calculateNewVelocity(body: PhysicsBody, acceleration: Vector, time: Double) -> Vector {
        let velocity = body.velocity
        let horizontalVelocity = velocity.x + (acceleration.x * time)
        let verticalVelocity = velocity.y + (acceleration.y * time)
        return Vector(x: horizontalVelocity, y: verticalVelocity)
    }

    func calculateNewPosition(body: PhysicsBody, time: Double) -> Vector {
        let position = body.position
        let velocity = body.velocity
        let horizontalPosition = position.x + (velocity.x * time)
        let verticalPosition = position.y + (velocity.y * time)
        return Vector(x: horizontalPosition, y: verticalPosition)
    }

}
