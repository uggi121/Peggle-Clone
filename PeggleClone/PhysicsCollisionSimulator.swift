//
//  PhysicsCollisionSimulator.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 14/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

struct PhysicsCollisionSimulator {
    func simulateCollisions(bodies: inout [String : PhysicsBody]) -> [String] {
        let boundingBoxes = bodies.mapValues({ $0.computeBoundingBox() })
        let possiblyCollidingBoxes = getPossiblyCollidingBoxes(boundingBoxes)
        return resolveAllCollisions(&bodies, possiblyCollidingBoxes)
    }

    /*
    private func computeBoundingBox(_ body: PhysicsBody) -> BoundingBox {
        let shape = body.shape

        switch shape {
        case .circle(let radius):
            let min = Vector(x: body.position.x - radius, y: body.position.y - radius)
            let max = Vector(x: body.position.x + radius, y: body.position.y + radius)
            return BoundingBox(min: min, max: max)

        case .rectangle(let halfWidth, let halfHeight):
            let min = Vector(x: body.position.x - halfWidth,
                             y: body.position.y - halfHeight)
            let max = Vector(x: body.position.x + halfWidth,
                             y: body.position.y + halfHeight)
            return BoundingBox(min: min, max: max)
        }
    }
    */

    private func getPossiblyCollidingBoxes(_ boundingBoxes: [String: BoundingBox]) -> [String : BoundingBox] {
        var possiblyCollidingBoundingBoxes = [String: BoundingBox]()
        for (tag, box) in boundingBoxes {
            for (innerTag, innerBox) in boundingBoxes {
                if box.intersectsWith(innerBox) {
                    possiblyCollidingBoundingBoxes[tag] = box
                    possiblyCollidingBoundingBoxes[innerTag] = innerBox
                }
            }
        }
        return possiblyCollidingBoundingBoxes
    }

    private func resolveAllCollisions(_ bodies: inout [String: PhysicsBody], _ boundingBoxes: [String : BoundingBox]) -> [String] {
        var tagsOfCollidingBodies = [String]()
        for (tag, _) in boundingBoxes {
            for (innerTag, _) in boundingBoxes where tag != innerTag {
                if areColliding(bodies[tag]!, bodies[innerTag]!) {
                    tagsOfCollidingBodies.append(tag)
                    tagsOfCollidingBodies.append(innerTag)
                    //resolveCollision(tag, innerTag, &bodies)
                    //performPositionalCorrections(tag, innerTag, &bodies)
                }
            }
        }

        return tagsOfCollidingBodies
    }

    private func areColliding(_ firstBody: PhysicsBody, _ secondBody: PhysicsBody) -> Bool {
        let firstShape = firstBody.shape
        let secondShape = secondBody.shape

        switch (firstShape, secondShape) {
        case (.circle(let firstRadius), .circle(let secondRadius)):
            return areCirclesColliding(firstBody.position, firstRadius, secondBody.position, secondRadius)
        }
    }

    private func areCirclesColliding(_ firstCirclePosition: Vector,
                                     _ firstCircleRadius: Double,
                                     _ secondCirclePosition: Vector,
                                     _ secondCircleRadius: Double) -> Bool {
        let squareDistance = firstCirclePosition.squareDistanceTo(vector: secondCirclePosition)
        let sumOfRadii = firstCircleRadius + secondCircleRadius
        return squareDistance < (sumOfRadii * sumOfRadii)
    }

    private func resolveCollision(_ firstTag: String, _ secondTag: String, _ bodies: inout [String: PhysicsBody]) {
        guard let firstObject = bodies[firstTag],
            let secondObject = bodies[secondTag] else {
            return
        }

        let relativeVelocity = secondObject.velocity.subtract(vector: firstObject.velocity)

        let collisionNormal = findCollisionNormal(firstObject, secondObject)
        let velocityAlongNormal = relativeVelocity.dotProductWith(vector: collisionNormal)

        /*
        if velocityAlongNormal > 0 {
            return
        }
        */

        var impulse = -(1 + PhysicsConstants.coefficientOfRestitution) * velocityAlongNormal
        impulse /= (1 / firstObject.mass) + (1 / secondObject.mass)

        let impulseVector = collisionNormal.multiplyWithScalar(scalar: impulse)
        let firstObjectVelocityChange = impulseVector.multiplyWithScalar(scalar: 1 / firstObject.mass)
        let secondObjectVelocityChange = impulseVector.multiplyWithScalar(scalar: 1 / secondObject.mass)

        bodies[firstTag]!.velocity = (bodies[firstTag]?.velocity.subtract(vector: firstObjectVelocityChange))!
        bodies[secondTag]!.velocity = (bodies[secondTag]?.velocity.addTo(vector: secondObjectVelocityChange))!

    }

    private func findCollisionNormal(_ firstBody: PhysicsBody, _ secondBody: PhysicsBody) -> Vector {
        let firstShape = firstBody.shape
        let secondShape = secondBody.shape

        switch (firstShape, secondShape) {
        case (.circle, .circle):
            let collisionNormal = firstBody.position.subtract(vector: secondBody.position)
            return collisionNormal.normalize()
        }
    }

    private func performPositionalCorrections(_ firstTag: String, _ secondTag: String, _ bodies: inout [String: PhysicsBody]) {

        let firstBody = bodies[firstTag]
        let secondBody = bodies[secondTag]

        guard firstBody != nil, secondBody != nil else {
            return
        }

        let firstShape = firstBody!.shape
        let secondShape = secondBody!.shape

        switch (firstShape, secondShape) {
        case (.circle(let firstRadius), .circle(let secondRadius)):
            let distance = sqrt(firstBody!.position.squareDistanceTo(vector: secondBody!.position))
            let sumOfRadii = firstRadius + secondRadius
            let penetration = sumOfRadii - distance
            let collisionNormal = findCollisionNormal(firstBody!, secondBody!)
            let percent = 1.0
            let threshold = 0.01
            let correctionScalar = max(penetration - threshold, 0.0) / (1 / firstBody!.mass + 1 / secondBody!.mass) * percent
            let correctionVector = collisionNormal.multiplyWithScalar(scalar: correctionScalar)
            let firstBodyCorrection = correctionVector.multiplyWithScalar(scalar: 1 / firstBody!.mass)
            let secondBodyCorrection = correctionVector.multiplyWithScalar(scalar: 1 / secondBody!.mass)

            bodies[firstTag]!.position = firstBody!.position.subtract(vector: firstBodyCorrection)
            bodies[secondTag]!.position = secondBody!.position.addTo(vector: secondBodyCorrection)
        default:
            return
        }
    }

}
