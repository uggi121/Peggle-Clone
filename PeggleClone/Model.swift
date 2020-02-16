//
//  Model.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 25/1/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

/// Models the game's underlying details.
class Model {

    private let gameBoard: GameBoard
    private var persistenceDelegate: PersistenceDelegate?
    private var ball: Ball?
    private let physicsWorld: PhysicsWorld
    private var counter = 0
    private var tagMap = [String: Point]()

    /// Initializes the model with the specified dimensions.
    init(dimensions: GameBoardDimensions) throws {
        self.gameBoard = GameBoard(dimensions: dimensions)
        let persistenceDelegate = try SqlitePersistenceManager()
        self.persistenceDelegate = persistenceDelegate
        self.ball = nil
        self.physicsWorld = PhysicsWorld(xMax: dimensions.xMax, yMax: dimensions.yMax)!
    }

    /// Adds a peg to the model.
    /// - Returns: `true` if the `Peg` was successfully added.
    func addPeg(peg: Peg) -> Bool {
        let wasAdded = gameBoard.addPeg(peg: peg)

        if wasAdded {
            let tag = String(counter)
            let centerOfPeg = Vector(x: peg.center.x, y: peg.center.y)
            let physicsBody = PegPhysicsBody(position: centerOfPeg)
            _ = physicsWorld.addPhysicsBody(body: physicsBody, tag: tag)
            tagMap[tag] = peg.center
            counter += 1
        }

        return wasAdded
    }

    /// Returns `true` if the specified `Peg` exists in the model.
    func containsPeg(peg: Peg) -> Bool {
        gameBoard.containsPeg(peg: peg)
    }

    /// Removes the `Peg` at the specified `Point` and returns it.
    /// If no `Peg` exists at the specifed `Point`, returns `nil`.
    func removePeg(at point: Point) -> Point? {
        gameBoard.removePeg(at: point)
    }

    /// Resets the model, removing all `Peg`s.
    func resetGame() {
        gameBoard.reset()
    }

    /// Loads the `Peg`s from the specified `fileName`.
    /// - Throws: `PersistenceError` if the loading is unsuccessful.
    func loadGame(fileName: String) throws -> Set<Peg> {

        guard persistenceDelegate != nil else {
            throw PersistenceError.persistenceFailure
        }

        let pegs = try persistenceDelegate!.loadGame(fileName: fileName)

        gameBoard.reset()
        pegs.forEach({ _ = gameBoard.addPeg(peg: $0) })

        return pegs
    }

    /// Saves the current model state into the specified`fileName`.
    /// - Throws: `PersistenceError` if the file cannot be saved under the specified name.
    func saveGame(fileName: String) throws {
        try persistenceDelegate?.saveGame(gameBoard: gameBoard, fileName: fileName)
    }

    func doesBallExist() -> Bool {
        if ball == nil {
            return false
        } else {
            return true
        }
    }

    func launchBallWithVelocity(velocity: Point) {
        guard ball == nil else {
            return
        }

        let topCenterPoint = gameBoard.getTopCenterPoint(offsetFromTop: 16)
        let topCenterPosition = Vector(x: topCenterPoint.x, y: topCenterPoint.y)
        var launchVelocity = Vector(x: velocity.x, y: velocity.y)
        let magnitude = launchVelocity.magnitude
        let thresholdVelocity = 250.0
        if magnitude > thresholdVelocity {
            launchVelocity = launchVelocity.multiplyWithScalar(scalar: 250 / magnitude)
        }

        ball = Ball(position: topCenterPosition, velocity: launchVelocity, radius: 16)
        physicsWorld.addPhysicsBody(body: ball!, tag: "ball")
        let gravityVector = Vector(x: 0, y: -PhysicsConstants.accelerationDueToGravity * 20)
        physicsWorld.applyForceOnBody(bodyTag: "ball", force: gravityVector)
    }

    func updateFor(time: Double) {
        //print(ball?.position.x, ball?.position.y)
        physicsWorld.simulateFor(time: time)

        if ball != nil && ball!.position.y < 16 {
            ball = nil
            _ = physicsWorld.removePhysicsBody(bodyTag: "ball")
            let removedPegs = gameBoard.removeHighlightedPegs()
            removedPegs.forEach({ physicsWorld.removePhysicsBody(bodyTag: tagMap.key(forValue: $0.center)!) })
        }

        let collidedBodyTags = physicsWorld.simulateCollisions()
        for tag in collidedBodyTags {
            let pegCenter = tagMap[tag]
            if pegCenter != nil {
                gameBoard.highlightPeg(at: pegCenter!)
            }
        }
    }

    func getBallPosition() -> Point? {
        guard ball != nil else {
            return nil
        }

        let position = ball!.position
        let point = Point(x: position.x, y: position.y)

        return point
    }

    func getHighlightedPegCoordinates() -> [Point] {
        gameBoard.getHighlightedPegCoordinates()
    }
}
