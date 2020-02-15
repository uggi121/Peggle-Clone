//
//  PhysicsBody.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 12/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

protocol PhysicsBody {
    var mass: Double { get }
    var velocity: Vector { get set }
    var forces: [Vector] { get set }
    var position: Vector { get set }
    var shape: Shape { get }

    func computeBoundingBox() -> BoundingBox
}
