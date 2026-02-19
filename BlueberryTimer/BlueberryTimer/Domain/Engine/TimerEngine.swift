//
//  TimerEngine.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

final class TimerEngine: TimerEngineProtocol {
    //MARK: Properties
    
    private let config: TimerConfig
    private(set) var state: TimerState
    
    init(config: TimerConfig) {
        self.config = config
        self.state = TimerState.initial(from: config)
    }
    
    func start() {
        guard !state.isFinished else { return }
        
        state = TimerState(
            mode: state.mode,
            phase: .running,
            totalSeconds: state.totalSeconds,
            remainingSeconds: state.remainingSeconds,
            currentRound: state.currentRound,
            totalRounds: state.totalRounds
        )
    }
    
    func pause() {
        guard !state.isFinished else { return }
        
        state = TimerState(
            mode: state.mode,
            phase: .paused,
            totalSeconds: state.totalSeconds,
            remainingSeconds: state.remainingSeconds,
            currentRound: state.currentRound,
            totalRounds: state.totalRounds)
    }
    
    func reset() {
        state = TimerState.initial(from: config)
    }
    
    // MARK: - Tick
    
    func tick() {
        guard state.isRunning else { return }
        guard state.remainingSeconds > 0 else {
            finish()
            return
        }
        
        let newRemaining = state.remainingSeconds - 1
        
        state = TimerState(
            mode: state.mode,
            phase: .running,
            totalSeconds: state.totalSeconds,
            remainingSeconds: newRemaining,
            currentRound: state.currentRound,
            totalRounds: state.totalRounds
        )
        
        handleModeSpecificLogic()
    }
}
// MARK: - Private helpers

private extension TimerEngine {
    
    func finish() {
        state = TimerState(
            mode: state.mode,
            phase: .finished,
            totalSeconds: state.totalSeconds,
            remainingSeconds: 0,
            currentRound: state.currentRound,
            totalRounds: state.totalRounds
        )
    }
    
    func handleModeSpecificLogic() {
        switch config.mode {
        case .emom:
            handleEMOM()
        case .amrap, .forTime, .tabata:
            break // implemented later
        }
    }
    
    func handleEMOM() {
        guard let interval = config.intervalSeconds, interval > 0 else { return }
        
        let elapsed = state.totalSeconds - state.remainingSeconds
        let newRound = max(1, (elapsed / interval) + 1)
        
        guard newRound != state.currentRound else { return }
        
        state = TimerState(
            mode: state.mode,
            phase: state.phase,
            totalSeconds: state.totalSeconds,
            remainingSeconds: state.remainingSeconds,
            currentRound: newRound,
            totalRounds: state.totalRounds
        )
    }
}
