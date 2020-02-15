//
//  PhysicsWorld.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 13/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

class PhysicsWorld {
    var bodies = [String: PhysicsBody]()
    private let physicsKinematicsSimulator = PhysicsKinematicsSimulator()
    private let physicsCollisionSimulator = PhysicsCollisionSimulator()
    var isGravityOn: Bool = false

    func addPhysicsBody(body: PhysicsBody, tag: String) -> Bool {
        guard !bodies.contains(where: { $0.key == tag }) else {
            return false
        }

        bodies[tag] = body
        return true
    }

    func removePhysicsBody(bodyTag: String) -> PhysicsBody? {
        bodies.removeValue(forKey: bodyTag)
    }

    func applyForceOnBody(bodyTag: String, force: Vector) {
        bodies[bodyTag]?.forces.append(force)
    }

    func removeForcesOnBody(bodyTag: String) {
        bodies[bodyTag]?.forces.removeAll()
    }

    func simulateFor(time: Double) {
        guard time > 0 else {
            return
        }

        physicsKinematicsSimulator.simulateWorldFor(time: time, bodies: &bodies)
    }

    func simulateCollisions() {
        physicsCollisionSimulator.simulateCollisions(bodies: &bodies)
    }
}
