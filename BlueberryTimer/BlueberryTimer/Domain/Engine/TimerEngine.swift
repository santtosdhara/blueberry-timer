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
        updateState(phase: .running)
    }
    
    func pause() {
        guard state.isRunning else { return }
        updateState(phase: .paused)
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

        let newTotalRemaining = state.remainingSeconds - 1

        var newIntervalRemaining = state.intervalRemainingSeconds
        if state.mode == .emom, let current = state.intervalRemainingSeconds {
            newIntervalRemaining = max(0, current - 1)
        }

        updateState(
            remainingSeconds: newTotalRemaining,
            intervalRemainingSeconds: newIntervalRemaining
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
            totalRounds: state.totalRounds,
            intervalSeconds: state.intervalSeconds,
            intervalRemainingSeconds: 0
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
        guard let interval = state.intervalSeconds,
              let intervalRemaining = state.intervalRemainingSeconds,
              let totalRounds = state.totalRounds else { return }

        // When interval hits 0, move to next round or finish
        if intervalRemaining == 0 {
            if state.currentRound >= totalRounds {
                finish()
                return
            }

            // Next round starts with interval reset
            updateState(
                currentRound: state.currentRound + 1,
                intervalRemainingSeconds: interval
            )
        }
    }
    
    func updateState(
        phase: TimerPhase? = nil,
        remainingSeconds: Int? = nil,
        currentRound: Int? = nil,
        intervalRemainingSeconds: Int? = nil
    ) {
        state = TimerState(
            mode: state.mode,
            phase: phase ?? state.phase,
            totalSeconds: state.totalSeconds,
            remainingSeconds: remainingSeconds ?? state.remainingSeconds,
            currentRound: currentRound ?? state.currentRound,
            totalRounds: state.totalRounds,
            intervalSeconds: state.intervalSeconds,
            intervalRemainingSeconds: intervalRemainingSeconds ?? state.intervalRemainingSeconds
        )
    }
}
