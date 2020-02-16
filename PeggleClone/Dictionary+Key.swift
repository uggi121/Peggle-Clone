//
//  Dictionary+Key.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 16/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {

    func key(forValue value: Value) -> Key? {
        first { $0.1 == value }?.0
    }
}
