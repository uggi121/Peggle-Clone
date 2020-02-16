//
//  BoundingBox.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 14/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Represents an AABB bounding box that can approximate a shape's boundary.
struct BoundingBox {
    let min: Vector
    let max: Vector

    /// Returns true if the bounding box intersects with the input bounding box.
    func intersectsWith(_ box: BoundingBox) -> Bool {
        let areHorizontallyIntersecting = (self.max.x > box.min.x && self.min.x < box.max.x)
        let areVerticallyIntersecting = (self.max.y > box.min.y && self.min.y < box.max.y)

        return areVerticallyIntersecting && areHorizontallyIntersecting
    }
}
