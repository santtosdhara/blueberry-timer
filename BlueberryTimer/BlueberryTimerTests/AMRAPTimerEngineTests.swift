//
//  AMRAPTimerEngineTests.swift
//  BlueberryTimerTests
//


import XCTest
@testable import BlueberryTimer

final class AMRAPTimerEngineTests: XCTestCase {

    // ─────────────────────────────────────────
    // MARK: - Helpers
    // ─────────────────────────────────────────

    /// Convenience: build an AMRAP engine without writing setup boilerplate in every test.
    private func makeEngine(minutes: Int = 20) -> TimerEngine {
        let config = TimerConfig.amrap(totalMinutes: minutes)
        return TimerEngine(config: config)
    }

    /// Tick the engine `n` times in a row (simulates n seconds passing).
    private func tick(_ engine: TimerEngine, times n: Int) {
        for _ in 0..<n { engine.tick() }
    }


    // ─────────────────────────────────────────
    // MARK: 1. Initial State
    // ─────────────────────────────────────────

    func test_amrap_initialState_phaseIsIdle() {
        // Arrange
        let engine = makeEngine(minutes: 10)

        // Assert — no Act needed; we are testing the starting condition
        XCTAssertEqual(engine.state.phase, .idle)
    }

    func test_amrap_initialState_remainingSecondsMatchesConfig() {
        // Arrange
        let engine = makeEngine(minutes: 10)

        // Assert
        XCTAssertEqual(engine.state.remainingSeconds, 600) // 10 min × 60
    }

    func test_amrap_initialState_totalSecondsMatchesConfig() {
        let engine = makeEngine(minutes: 5)
        XCTAssertEqual(engine.state.totalSeconds, 300) // 5 min × 60
    }

    func test_amrap_initialState_modeIsAMRAP() {
        let engine = makeEngine()
        XCTAssertEqual(engine.state.mode, .amrap)
    }

    func test_amrap_initialState_hasNoRounds() {
        // AMRAP doesn't count rounds automatically — totalRounds should be nil
        let engine = makeEngine()
        XCTAssertNil(engine.state.totalRounds)
    }


    // ─────────────────────────────────────────
    // MARK: 2. Start
    // ─────────────────────────────────────────

    func test_amrap_afterStart_phaseIsRunning() {
        // Arrange
        let engine = makeEngine()

        // Act
        engine.start()

        // Assert
        XCTAssertEqual(engine.state.phase, .running)
    }

    func test_amrap_start_doesNotChangeRemainingSeconds() {
        // Pressing Start should not skip any time
        let engine = makeEngine(minutes: 10)
        engine.start()
        XCTAssertEqual(engine.state.remainingSeconds, 600)
    }


    // ─────────────────────────────────────────
    // MARK: 3. Ticking (time progression)
    // ─────────────────────────────────────────

    func test_amrap_oneTick_decrementsRemainingByOne() {
        // Arrange
        let engine = makeEngine(minutes: 5) // 300 seconds
        engine.start()

        // Act
        engine.tick()

        // Assert
        XCTAssertEqual(engine.state.remainingSeconds, 299)
    }

    func test_amrap_multipleTicks_decrementsCorrectly() {
        let engine = makeEngine(minutes: 5) // 300 seconds
        engine.start()

        tick(engine, times: 45)

        XCTAssertEqual(engine.state.remainingSeconds, 255)
    }

    func test_amrap_tick_beforeStart_doesNotDecrementTime() {
        // Ticks should be ignored when engine is not running
        let engine = makeEngine(minutes: 5)

        // No engine.start() call
        engine.tick()
        engine.tick()

        XCTAssertEqual(engine.state.remainingSeconds, 300)
        XCTAssertEqual(engine.state.phase, .idle)
    }


    // ─────────────────────────────────────────
    // MARK: 4. Pause & Resume
    // ─────────────────────────────────────────

    func test_amrap_afterPause_phaseIsPaused() {
        let engine = makeEngine()
        engine.start()

        engine.pause()

        XCTAssertEqual(engine.state.phase, .paused)
    }

    func test_amrap_tick_whenPaused_doesNotDecrementTime() {
        // Arrange
        let engine = makeEngine(minutes: 5)
        engine.start()
        tick(engine, times: 10) // advance 10 seconds
        let secondsBeforePause = engine.state.remainingSeconds

        // Act
        engine.pause()
        tick(engine, times: 10) // these ticks should be ignored

        // Assert
        XCTAssertEqual(engine.state.remainingSeconds, secondsBeforePause)
    }

    func test_amrap_resume_afterPause_continuesDecrementing() {
        let engine = makeEngine(minutes: 5)
        engine.start()
        tick(engine, times: 10) // 290 seconds remaining
        engine.pause()

        // Resume = call start() again
        engine.start()
        tick(engine, times: 5)

        XCTAssertEqual(engine.state.remainingSeconds, 285)
        XCTAssertEqual(engine.state.phase, .running)
    }

    func test_amrap_pause_whenAlreadyPaused_doesNothing() {
        let engine = makeEngine()
        engine.start()
        engine.pause()

        // Calling pause a second time should be a no-op
        engine.pause()

        XCTAssertEqual(engine.state.phase, .paused)
    }


    // ─────────────────────────────────────────
    // MARK: 5. Finish Condition
    // ─────────────────────────────────────────

    func test_amrap_afterAllTicksElapse_phaseIsFinished() {
        // Arrange — use 1 minute for test speed
        let engine = makeEngine(minutes: 1) // 60 ticks to finish
        engine.start()

        // Act
        tick(engine, times: 60)

        // Assert
        XCTAssertEqual(engine.state.phase, .finished)
    }

    func test_amrap_afterAllTicksElapse_remainingSecondsIsZero() {
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 60)

        XCTAssertEqual(engine.state.remainingSeconds, 0)
    }

    func test_amrap_extraTicksAfterFinish_doNotChangeState() {
        // Once finished, further ticks should be completely ignored
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 60) // timer finishes here

        // Act — tick more after finish
        tick(engine, times: 10)

        // Assert — state frozen at finished
        XCTAssertEqual(engine.state.phase, .finished)
        XCTAssertEqual(engine.state.remainingSeconds, 0)
    }

    func test_amrap_start_whenAlreadyFinished_doesNotRestart() {
        // Pressing Start on a finished timer should not reopen it
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 60)

        engine.start() // attempt to restart

        XCTAssertEqual(engine.state.phase, .finished)
    }


    // ─────────────────────────────────────────
    // MARK: 6. Reset
    // ─────────────────────────────────────────

    func test_amrap_reset_fromRunning_returnsToIdle() {
        let engine = makeEngine(minutes: 5)
        engine.start()
        tick(engine, times: 30)

        engine.reset()

        XCTAssertEqual(engine.state.phase, .idle)
    }

    func test_amrap_reset_restoresFullRemainingSeconds() {
        let engine = makeEngine(minutes: 5) // 300 seconds
        engine.start()
        tick(engine, times: 30) // 270 remaining

        engine.reset()

        XCTAssertEqual(engine.state.remainingSeconds, 300)
    }

    func test_amrap_reset_fromFinished_allowsRestart() {
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 60)
        engine.reset()

        engine.start()
        engine.tick()

        XCTAssertEqual(engine.state.phase, .running)
        XCTAssertEqual(engine.state.remainingSeconds, 59)
    }


    // ─────────────────────────────────────────
    // MARK: 7. Edge Cases
    // ─────────────────────────────────────────

    func test_amrap_minimumValidDuration_oneMinute() {
        // The factory clamps to max(0, totalMinutes), so 1 is the real minimum
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 59)

        XCTAssertEqual(engine.state.remainingSeconds, 1)
        XCTAssertEqual(engine.state.phase, .running)

        engine.tick() // 60th tick — should finish now

        XCTAssertEqual(engine.state.phase, .finished)
        XCTAssertEqual(engine.state.remainingSeconds, 0)
    }

    func test_amrap_lastTickTransitionsToFinished_notBelow() {
        // Remaining should land exactly at 0, never go negative
        let engine = makeEngine(minutes: 1)
        engine.start()
        tick(engine, times: 60)

        XCTAssertGreaterThanOrEqual(engine.state.remainingSeconds, 0)
    }
}
