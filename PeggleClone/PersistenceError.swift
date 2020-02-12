//
//  DatabaseError.swift
//  Peggle
//
//  Created by Sudharshan Madhavan on 2/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

enum PersistenceError: Error {
    case persistenceFailure
    case fileAlreadyExists
    case noSuchFileExists
}
