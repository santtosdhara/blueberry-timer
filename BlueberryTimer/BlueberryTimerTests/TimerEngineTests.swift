//
//  TimerEngineTests.swift
//  BlueberryTimerTests
//
//  Created by Dhara Chavez on 3/23/26.
//

import XCTest
@testable import BlueberryTimer


@MainActor
final class TimerEngineTests: XCTestCase {

    //Very descriptive name
    func test_emom_advancesToNextRoundAfterFullInterval() {
        //what do I need to execute this test?
        let config = TimerConfig.emom(intervalMinutes: 1, rounds: 3)
        let engine = TimerEngine(config: config)
        
        engine.start()
        
        //Act
        //1 minute = 60 seconds
        
        for _ in 0..<60 {
            engine.tick()
        }
        
        //Asserts, this is what we expect after the action above happened
        XCTAssertEqual(engine.state.currentRound, 2)
        XCTAssertEqual(engine.state.intervalRemainingSeconds, 60)
        XCTAssertEqual(engine.state.phase, .running)
    }
}
