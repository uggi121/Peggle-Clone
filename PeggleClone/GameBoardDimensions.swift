//
//  GameBoardDimension.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 1/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation
import UIKit

/// Encapsulates the dimensions of the model's `GameBoard`.
struct GameBoardDimensions {
    let xMin: Double
    let xMax: Double
    let yMin: Double
    let yMax: Double
    let minimumSize: Double

    init?(xMin: Double, xMax: Double, yMin: Double, yMax: Double, minimumSize: Double) {
        self.minimumSize = minimumSize

        guard minimumSize > 0 else {
            return nil
        }

        let areHorizontalLocationsValid = xMin + minimumSize <= xMax
        let areVerticalLocationsValid = yMin + minimumSize <= yMax

        guard areVerticalLocationsValid && areHorizontalLocationsValid else {
            return nil
        }

        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
    }

    /// Returns `true` if the specified `Peg` is within bounds.
    func isPegWithinBounds(center: Point, radius: Double) -> Bool {
        let isRightSideWithinBounds = center.x + radius < xMax
        let isLeftSideWithinBounds = center.x - radius > xMin
        let isTopSideWithinBounds = center.y + radius < yMax
        let isBottomSideWithinBounds = center.y - radius > yMin
        return isTopSideWithinBounds && isLeftSideWithinBounds && isRightSideWithinBounds && isBottomSideWithinBounds
    }
}
