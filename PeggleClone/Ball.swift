//
//  Ball.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 16/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

class Ball {
    private var radius: Double
    private var center: Point

    init?(center: Point, radius: Double) {
        guard radius > 0 else {
            return nil
        }

        self.center = center
        self.radius = radius
    }
}
