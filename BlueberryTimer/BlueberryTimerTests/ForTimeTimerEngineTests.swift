//
//  ForTimeTimerEngineTests.swift
//  BlueberryTimerTests
//
//  Created by Dhara Chavez on 4/17/26.
//


import XCTest
@testable import BlueberryTimer

@MainActor
final class ForTimeTimerEngineTests: XCTestCase {
    
    //MARK: Helpers
    private func makeEngine(minutes: Int = 20) -> TimerEngine {
        let config = TimerConfig.forTime(totalMinutes: minutes)
        return TimerEngine(config: config)
    }

    /// Tick the engine `n` times in a row (simulates n seconds passing).
    private func tick(_ engine: TimerEngine, times n: Int) {
        for _ in 0..<n { engine.tick() }
    }
    
    //MARK: Initial State
    
    ///Initial phase
    func test_forTime_initialState_phaseIsIdle() {
        
        let engine = makeEngine(minutes: 12)
        
        XCTAssert(engine.state.phase == .idle)
    }
    
    ///Initial time
    func test_forTime_initialState_remainingSecondsMatchesConfig() {
        
        let engine = makeEngine(minutes: 12)
        
        XCTAssert(engine.state.remainingSeconds == 720)
    }
    
    func test_forTime_initialState_modeIsForTime() {
        let engine = makeEngine(minutes: 10)
        
        XCTAssert(engine.state.mode == .forTime)
    }
    
    
    //MARK: Elapsed logic
    
    func test_forTime_afterOneTick_elapsedTimeIsOne() {
        let engine = makeEngine(minutes: 5)
    
        engine.start()
        
        engine.tick()
        
        XCTAssertEqual(engine.state.totalSeconds - engine.state.remainingSeconds, 1)
    }
    
    func test_forTime_afterMultipleTicks_elapsedTimeIsSumOfTicks() {
        let engine = makeEngine(minutes: 5)
        
        engine.start()

        tick(engine, times: 10)
        
        XCTAssertEqual(engine.state.totalSeconds - engine.state.remainingSeconds, 10)
    }
    
    func test_forTime_tickBeforeStart_doesNotChangeState() {
        let engine = makeEngine(minutes: 10)
        
        engine.tick()
        
        XCTAssert(engine.state.phase == .idle)
    }
    
    
    //MARK: Pause
    
    //@TODO finish writing this test
    func test_forTime_tick_whenPaused_doesNotAdvanceElapsedTime() {
        let engine = makeEngine(minutes: 10)
        
        engine.start()
        tick(engine, times: 1)
        
        let secondsBeforePause = engine.state.remainingSeconds
        
        engine.pause()
        tick(engine, times: 1)
        
        XCTAssertEqual(engine.state.remainingSeconds, secondsBeforePause)
        
    }
}
