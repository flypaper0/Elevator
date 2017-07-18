//
//  Elevator.swift
//  Elevator
//
//  Created by Artur Guseinov on 13/07/2017.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

import UIKit

struct Elevator {

    let settings: Settings
    
    var targetFloor: Float = 1
    var currentFloor: Float = 1
    var isDoorClosed = true
    
    init(settings: Settings) {
        self.settings = settings
    }
}
