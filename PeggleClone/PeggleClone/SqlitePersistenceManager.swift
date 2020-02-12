//
//  SqlitePersistenceManager.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 2/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation
import SQLite3

/// Manages the persistence of model data by using an SQLite Database.
class SqlitePersistenceManager: PersistenceDelegate {

    private var database: OpaquePointer?

    /// Initializes an SQLite database to store levels.
    /// - Throws: `PersistenceError` if the database cannot be created.
    init() throws {
        let filePath = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent("database.sqlite")

        guard sqlite3_open(filePath.path, &database) == SQLITE_OK else {
            throw PersistenceError.persistenceFailure
        }
    }

    /// Saves the input `GameBoard` under the given `fileName`.
    /// - Throws: `PersistenceError` if the file name is invalid, or if a fille of the same name exists.
    func saveGame(gameBoard: GameBoard, fileName: String) throws {
        guard sqlite3_exec(database, createTable(tableName: fileName),
                           nil, nil, nil) == SQLITE_OK else {
                throw PersistenceError.fileAlreadyExists
        }

        let saveQueryString = makeInsertStatement(fileName: fileName)
        var saveQuery: OpaquePointer?

        for peg in gameBoard.getPegs() {
            guard sqlite3_prepare(database, saveQueryString, -1, &saveQuery, nil) == SQLITE_OK else {
                throw PersistenceError.persistenceFailure
            }

            // Bind the parameters to the query.
            sqlite3_bind_double(saveQuery, 1, peg.center.x)
            sqlite3_bind_double(saveQuery, 2, peg.center.y)
            sqlite3_bind_double(saveQuery, 3, peg.radius)
            sqlite3_bind_text(saveQuery, 4, peg.color.rawValue, -1, nil)

            guard sqlite3_step(saveQuery) == SQLITE_DONE else {
                throw PersistenceError.persistenceFailure
            }

        }

    }

    /// Loads the file saved under the name `fileName.
    /// - Returns: A set of `Peg`s representing the saved level.
    /// - Throws: `PersistenceError`if the entered file name is invalid.
    func loadGame(fileName: String) throws -> Set<Peg> {
        var query: OpaquePointer?
        let queryString = makeSelectStatement(fileName: fileName)

        guard sqlite3_prepare(database, queryString, -1, &query, nil) == SQLITE_OK else {
            throw PersistenceError.noSuchFileExists
        }

        var pegs = Set<Peg>()

        while sqlite3_step(query) == SQLITE_ROW {
            // Retrieve arguments from the query.
            let x = sqlite3_column_double(query, 0)
            let y = sqlite3_column_double(query, 1)
            let radius = sqlite3_column_double(query, 2)
            let colorString = String(cString: sqlite3_column_text(query, 3))
            var color: Color

            if colorString == "blue" {
                color = .blue
            } else {
                color = .orange
            }

            let peg = Peg(center: Point(x: x, y: y), radius: radius, color: color)
            pegs.insert(peg!)
        }

        return pegs
    }

    private func createTable(tableName: String) -> String {
        "CREATE TABLE \(tableName) (x REAL, y REAL, radius REAL, color TEXT)"
    }

    private func makeInsertStatement(fileName: String) -> String {
        "INSERT INTO \(fileName) VALUES (?, ?, ?, ?)"
    }

    private func makeSelectStatement(fileName: String) -> String {
        "SELECT * FROM \(fileName)"
    }

}
