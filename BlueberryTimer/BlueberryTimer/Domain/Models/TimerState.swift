//
//  TimerState.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

struct TimerState: Equatable {
    let mode: TimerMode
    let phase: TimerPhase
    
    let totalSeconds: Int
    let remainingSeconds: Int
    
    //EMOM/ Tabata
    let currentRound: Int
    let totalRounds: Int?
    
    var isRunning: Bool { phase == .running || phase == .work || phase == .rest }
    var isPaused: Bool { phase == .paused }
    var isFinished: Bool { phase == .finished }
    
    static func initial(from config: TimerConfig) -> TimerState {
        switch config.mode {
        case .emom:
            let rounds = max(1, config.totalSeconds / max(1, config.intervalSeconds ?? 60))
            return TimerState(
                mode: .emom,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 1,
                totalRounds: rounds
            )
            
        case .amrap:
            return TimerState(
                mode: .amrap,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 0,
                totalRounds: nil
            )
            
        case .forTime:
            return TimerState(
                mode: .forTime,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 0,
                totalRounds: nil
            )
            
        case .tabata:
            let rounds = max(1, config.rounds ?? 8)
            return TimerState(
                mode: .tabata,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 1,
                totalRounds: rounds
            )
        }
    }
}
