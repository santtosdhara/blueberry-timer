//
//  TimerEngineProtocol.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

/// Domain-level contract for timer behavior.
/// - Why: Keeps UI/ViewModels decoupled from implementation details and makes the engine mockable for tests.
/// - Note: Engine is deterministic; it does not schedule time. Time is driven externally via a Ticker.

protocol TimerEngineProtocol: AnyObject {
    
    var state: TimerState { get }
    
    //MARK: - Lyfecycle
    
    func start()
    func pause()
    func reset()
    
    //MARK: - Time progression
    func tick()
}
