//
//  PersistenceDelegate.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 2/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

protocol PersistenceDelegate: AnyObject {
    func saveGame(gameBoard: GameBoard, fileName: String) throws

    func loadGame(fileName: String) throws -> Set<Peg>
}
