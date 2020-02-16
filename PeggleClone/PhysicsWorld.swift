//
//  PhysicsWorld.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 13/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Represents the physical world governed by the physics engine.
class PhysicsWorld {
    var bodies = [String: PhysicsBody]()
    private let physicsKinematicsSimulator = PhysicsKinematicsSimulator()
    private let physicsCollisionSimulator: PhysicsCollisionSimulator

    /// Initializes the physics engine with the entered bounds.
    /// The minimal bounds are assumed to be zero horizontally and vertically.
    /// Returns nil if the entered upper bounds are invalid.
    init?(xMax: Double, yMax: Double) {
        guard xMax > 0, yMax > 0 else {
            return nil
        }

        self.physicsCollisionSimulator = PhysicsCollisionSimulator(xMax: xMax, yMax: yMax)!
    }

    /// Adds a `PhysicsBody` to the physics engine with the entered `tag`.
    /// - Parameters:
    ///     - body: the `PhysicsBody` to be added.
    ///     - tag: the body's tag.
    /// - Returns: true if the addition is successful.
    func addPhysicsBody(body: PhysicsBody, tag: String) -> Bool {
        guard !bodies.contains(where: { $0.key == tag }) else {
            return false
        }

        bodies[tag] = body
        return true
    }

    /// Removes and returns the `PhysicsBody` mapped to the entered `tag`.
    /// Returns `nil` if the `tag` doesn't map to any existing body in the physics engine.
    func removePhysicsBody(bodyTag: String) -> PhysicsBody? {
        bodies.removeValue(forKey: bodyTag)
    }

    /// Applies the specified force on the body that maps to the entered `tag`.
    func applyForceOnBody(bodyTag: String, force: Vector) {
        bodies[bodyTag]?.forces.append(force)
    }

    /// Removes all the forces acting on the body that maps to the entered `tag`.
    func removeForcesOnBody(bodyTag: String) {
        bodies[bodyTag]?.forces.removeAll()
    }

    /// Simulates the physics world for the entered amount of time.
    /// Moves the bodies to their projected positions and updates their velocities.
    func simulateFor(time: Double) {
        guard time > 0 else {
            return
        }

        physicsKinematicsSimulator.simulateWorldFor(time: time, bodies: &bodies)
    }

    /// Simulates any possible collisions that might occur between the physics bodies.
    /// Returns a list of `tag`s of the bodies that are involved in a collision.
    func simulateCollisions() -> [String] {
        physicsCollisionSimulator.simulateCollisions(bodies: &bodies)
    }
}
