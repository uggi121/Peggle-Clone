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

    /// Initializes the model with the specified dimensions.
    init(dimensions: GameBoardDimensions) throws {
        self.gameBoard = GameBoard(dimensions: dimensions)
        let persistenceDelegate = try SqlitePersistenceManager()
        self.persistenceDelegate = persistenceDelegate
    }

    /// Adds a peg to the model.
    /// - Returns: `true` if the `Peg` was successfully added.
    func addPeg(peg: Peg) -> Bool {
        gameBoard.addPeg(peg: peg)
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
}
