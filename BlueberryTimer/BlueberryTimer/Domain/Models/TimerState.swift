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
    
    let intervalSeconds: Int?
    let intervalRemainingSeconds: Int?
    var isRunning: Bool { phase == .running || phase == .work || phase == .rest }
    var isPaused: Bool { phase == .paused }
    var isFinished: Bool { phase == .finished }
    
    static func initial(from config: TimerConfig) -> TimerState {
        switch config.mode {
        case .emom:
            let totalRounds = max(1, config.rounds ?? 1)
            let interval = max(1, config.intervalSeconds ?? 60)
            return TimerState(
                mode: .emom,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 1,
                totalRounds: totalRounds,
                intervalSeconds: interval,
                intervalRemainingSeconds: interval
            )
            
        case .amrap:
            return TimerState(
                mode: .amrap,
                phase: .idle,
                totalSeconds: config.totalSeconds,
                remainingSeconds: config.totalSeconds,
                currentRound: 0,
                totalRounds: nil,
                intervalSeconds: nil,
                intervalRemainingSeconds: nil
            )
            
        case .forTime:
                   return TimerState(
                       mode: .forTime,
                       phase: .idle,
                       totalSeconds: config.totalSeconds,
                       remainingSeconds: config.totalSeconds,
                       currentRound: 0,
                       totalRounds: nil,
                       intervalSeconds: nil,
                       intervalRemainingSeconds: nil
                   )

               case .tabata:
                   let rounds = max(1, config.rounds ?? 8)
                   return TimerState(
                       mode: .tabata,
                       phase: .work,
                       totalSeconds: config.totalSeconds,
                       remainingSeconds: config.totalSeconds,
                       currentRound: 1,
                       totalRounds: rounds,
                       intervalSeconds: nil,
                       intervalRemainingSeconds: config.workSeconds
                   )
        }
    }
}
