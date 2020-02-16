//
//  GameBoard.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 25/1/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Encapsulates the playing field of the model.
class GameBoard {
    private(set) var pegs = Set<Peg>()
    private let dimensions: GameBoardDimensions

    init(dimensions: GameBoardDimensions) {
        self.dimensions = dimensions
    }

    /// Adds a `Peg` to the `GameBoard`.
    /// Returns `true` if the peg was successfully added.
    func addPeg(peg: Peg) -> Bool {
        guard canBeAdded(peg: peg) else {
            return false
        }

        pegs.insert(peg)
        return true
    }

    /// Removed the `Peg` at the specified point.
    /// The `Peg` which contains the entered point is removed. The point need not be the center of the `Peg`.
    /// - Returns: `Point` representing the center of the removed `Peg`.
    func removePeg(at point: Point) -> Point? {
        let pegsToBeRemoved = pegs.filter({ $0.containsPoint(point: point) })
        guard !pegsToBeRemoved.isEmpty else {
            return nil
        }

        pegs.subtract(pegsToBeRemoved)
        return pegsToBeRemoved.first?.center
    }

    /// Checks if the specified `Peg` is present.
    func containsPeg(peg: Peg) -> Bool {
        pegs.contains(peg)
    }

    /// Returns a copy of the set of `Peg`s.
    func getPegs() -> Set<Peg> {
        Set(pegs.map({ $0.copy() }))
    }

    /// Resets the board.
    func reset() {
        pegs.removeAll()
    }

    private func canBeAdded(peg: Peg) -> Bool {
        for existingPeg in pegs
            where areIntersecting(firstPeg: existingPeg, secondPeg: peg) {
                return false
        }

        if !dimensions.isPegWithinBounds(center: peg.center, radius: peg.radius) {
            return false
        }

        return true
    }

    private func areIntersecting(firstPeg: Peg, secondPeg: Peg) -> Bool {
        let sumOfRadii = firstPeg.radius + secondPeg.radius
        let centerOfFirstPeg = firstPeg.center
        let centerOfSecondPeg = secondPeg.center
        let distanceBetweenCenters = centerOfFirstPeg.calculateDistanceTo(point: centerOfSecondPeg)

        return sumOfRadii > distanceBetweenCenters
    }

    func getTopCenterPoint(offsetFromTop: Double) -> Point {
        Point(x: (dimensions.xMax + dimensions.xMin) / 2, y: dimensions.yMax - offsetFromTop)
    }

    func highlightPeg(at point: Point) {
        let pegsContainingPoint = pegs.filter({ $0.containsPoint(point: point) })
        guard !pegsContainingPoint.isEmpty else {
            return
        }

        pegsContainingPoint.first!.highlight()
    }

    func getHighlightedPegCoordinates() -> [Point] {
        let highlightedPegs = pegs.filter({ $0.isHighlighted })
        return highlightedPegs.map({ $0.center })
    }

    func removeHighlightedPegs() -> Set<Peg> {
        let highlightedPegs = pegs.filter({ $0.isHighlighted })
        pegs.subtract(highlightedPegs)
        return highlightedPegs
    }
}
