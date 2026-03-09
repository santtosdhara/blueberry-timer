//
//  TimerViewModel.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import Foundation
import Observation

/// Presentation-layer orchestrator.
/// Responsibility:
/// - Start/stop the Ticker (side effect)
/// - Delegate business rules to the Domain TimerEngine
/// - Expose TimerState to SwiftUI as a single source of truth

@Observable
final class TimerViewModel {
    
    private let engine: TimerEngineProtocol
    private let ticker: Ticker
    
    private(set) var state: TimerState
    
    init(engine: TimerEngineProtocol, ticker: Ticker) {
        self.engine = engine
        self.ticker = ticker
        self.state = engine.state
    }
    
    deinit {
        ticker.stop()
    }
    
    func start() {
        engine.start()
        state = engine.state
        
        ticker.start(every: 1.0) { [weak self] in
            guard let self else { return }
            self.engine.tick()
            self.state = self.engine.state
            
            if self.state.isFinished {
                self.ticker.stop()
            }
        }
    }
    
    func pause() {
        engine.pause()
        state = engine.state
        ticker.stop()
    }
    
    func reset() {
        ticker.stop()
        engine.reset()
        state = engine.state
    }
    
    func resume() {
        start()
    }
}
