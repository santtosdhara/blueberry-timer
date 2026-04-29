//
//  AMRAPConfigViewModel.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 4/28/26.
//

import Foundation
import Observation

@Observable
final class AMRAPConfigViewModel {
    var minutesText: String = "12"
    
    private var totalMinutes: Int {
        Int(minutesText) ?? 0
    }
    
    func makeTimerViewModel() -> TimerViewModel {
        let config = TimerConfig.amrap(totalMinutes: max(1, totalMinutes))
        let engine = TimerEngine(config: config)
        let ticker = SystemTicker()
        
        return TimerViewModel(engine: engine, ticker: ticker)
    }
    
}
