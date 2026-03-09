//
//  TimerEngine.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

/// Domain timer engine.
/// Responsibility:
/// - Own all business rules (round transitions, finish conditions, per-mode behavior).
/// - Remain UI-agnostic (no SwiftUI, no Timer/Combine scheduling).
///
/// Design:
/// - Time is injected/external: a Ticker calls `tick()` every second.
/// - State is modeled as a value type (TimerState) for predictability and testability.

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
        // Engine advances only when running; it is deterministic and driven by external ticks.
        guard state.isRunning else { return }
        guard state.remainingSeconds > 0 else {
            finish()
            return
        }

        let newTotalRemaining = state.remainingSeconds - 1
        
        // Mode-specific countdown (EMOM shows interval countdown instead of total countdown).
        var newIntervalRemaining = state.intervalRemainingSeconds
        if state.mode == .emom, let current = state.intervalRemainingSeconds {
            newIntervalRemaining = max(0, current - 1)
        }

        // Centralized update keeps TimerState construction consistent as fields evolve.
        updateState(
            remainingSeconds: newTotalRemaining,
            intervalRemainingSeconds: newIntervalRemaining
        )

        // Allow each mode to react to a tick (round transitions, phase changes, etc.).
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
        // EMOM rule: show per-interval countdown and repeat it for N rounds.
        // When the interval reaches 0:
        // - If last round: finish
        // - Else: increment round and reset interval countdown back to full interval seconds
        
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
    
    /// Centralized state mutation helper.
    /// - Why: Avoids repeating full TimerState construction in multiple methods.
    /// - Benefit: When we add fields for AMRAP/Tabata later, we update state safely in one place.
    
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
