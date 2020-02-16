//
//  PegPhysicsBody.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 16/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

class PegPhysicsBody: PhysicsBody {
    var mass: Double = Double.infinity
    var velocity: Vector = Vector(x: 0, y: 0)
    var forces = [Vector]()
    var position: Vector
    var shape: Shape = .circle(32)
    
    func computeBoundingBox() -> BoundingBox {
        let min = Vector(x: self.position.x - 32, y: self.position.y - 32)
        let max = Vector(x: self.position.x + 32, y: self.position.y + 32)
        return BoundingBox(min: min, max: max)
    }

    init(position: Vector) {
        self.position = position
    }

}
