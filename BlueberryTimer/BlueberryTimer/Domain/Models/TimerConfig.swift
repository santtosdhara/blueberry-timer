//
//  TimerConfig.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

struct TimerConfig: Equatable {
    let mode: TimerMode
    let totalSeconds: Int
    
    //Emom specifics
    let intervalSeconds: Int?
    
    //Tabata specifics
    let workSeconds: Int?
    let restSeconds: Int?
    let rounds: Int?
    
    static func emom(totalMinutes: Int, intervalSeconds: Int = 60) -> TimerConfig {
        TimerConfig(
            mode: .emom,
            totalSeconds: max(0, totalMinutes) * 60,
            intervalSeconds: max(1, intervalSeconds),
            workSeconds: nil,
            restSeconds: nil,
            rounds: nil
        )
    }
    
    static func amrap(totalMinutes: Int) -> TimerConfig {
        TimerConfig(
            mode: .amrap,
            totalSeconds: max(0, totalMinutes) * 60,
            intervalSeconds: nil,
            workSeconds: nil,
            restSeconds: nil,
            rounds: nil
        )
    }
    
    static func forTime(totalMinutes: Int) ->TimerConfig {
        TimerConfig(
            mode: .forTime,
            totalSeconds: max(0, totalMinutes) * 60,
            intervalSeconds: nil,
            workSeconds: nil,
            restSeconds: nil,
            rounds: nil
        )
    }
    
    static func tabata(workSeconds: Int = 20, restSeconds: Int = 10, rounds: Int = 8) -> TimerConfig {
        let work = max(1, workSeconds)
        let rest = max(1, restSeconds)
        let roundsNumber = max(1, rounds)
        return TimerConfig(
            mode: .tabata,
            totalSeconds: (work + rest) * roundsNumber,
            intervalSeconds: nil,
            workSeconds: work,
            restSeconds: rest,
            rounds: roundsNumber
        )
    }
    
}
