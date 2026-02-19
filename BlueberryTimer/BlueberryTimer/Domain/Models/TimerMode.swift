//
//  TimerMode.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

enum TimerMode: String, CaseIterable, Identifiable {
    case emom = "EMOM"
    case amrap = "AMRAP"
    case forTime = "For Time"
    case tabata = "Tabata"
    
    var id: String { rawValue }
    
    var shortDescription: String {
            switch self {
            case .emom: return "Every minute on the minute"
            case .amrap: return "As many rounds as possible"
            case .forTime: return "Complete work as fast as possible"
            case .tabata: return "Intervals of work and rest"
            }
        }
}
