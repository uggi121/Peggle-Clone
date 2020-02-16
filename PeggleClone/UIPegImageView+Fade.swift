//
//  UIImageView+Fade.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 16/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import Foundation
import UIKit

extension UIPegImageView {
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: 1.5, animations: {
            self.alpha = 0.0
        })
    }
}
