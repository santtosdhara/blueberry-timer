//
//  TimerPhase.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

enum TimerPhase: Equatable {
    case idle
    case running
    case paused
    case finished
    
    //Mode-specific sub-phase used mainly on Tabata timer
    case work
    case rest
}
