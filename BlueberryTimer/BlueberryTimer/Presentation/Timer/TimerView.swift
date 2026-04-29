//
//  TimerView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import SwiftUI

struct TimerView: View {
    @State var viewModel: TimerViewModel
    
    // Displayed time varies by mode:
    // - EMOM shows interval countdown
    // - For Time shows elapsed time
    // - AMRAP/Tabata show remaining time
    
    private var displaySeconds: Int {
        switch viewModel.state.mode {
        case .emom:
            return viewModel.state.intervalRemainingSeconds ?? viewModel.state.remainingSeconds
        case .tabata:
            return viewModel.state.intervalRemainingSeconds ?? viewModel.state.remainingSeconds
        case .forTime:
            return viewModel.state.totalSeconds - viewModel.state.remainingSeconds
        case .amrap:
            return viewModel.state.remainingSeconds
        }
    }

    var body: some View {
        VStack(spacing: 36) {
            Text(viewModel.state.mode.rawValue)
                .font(.title2)
                .fontWeight(.semibold)
            
    

            TimeDisplay(remainingSeconds: displaySeconds)

            if let totalRounds = viewModel.state.totalRounds, totalRounds > 0 {
                Text("Round \(viewModel.state.currentRound) of \(totalRounds)")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                if viewModel.state.isRunning {
                    Button("Pause") { viewModel.pause() }
                        .buttonStyle(.borderedProminent)
                    
                } else if viewModel.state.isPaused {
                    Button("Resume") { viewModel.resume() }
                        .buttonStyle(.borderedProminent)
                } else if viewModel.state.phase == .idle {
                    Button("Start") { viewModel.start() }
                        .buttonStyle(.borderedProminent)
                } else if viewModel.state.isFinished {
                    Text("Finished 🎉")
                        .font(.headline)
                }

                Button("Reset") { viewModel.reset() }
                    .buttonStyle(.bordered)
            }
        }
        .padding(40)
        .navigationTitle("Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = TimerConfig.emom(intervalMinutes: 1, rounds: 2)
    let engine = TimerEngine(config: config)
    let ticker = NoopTicker()

    NavigationStack {
        TimerView(viewModel: TimerViewModel(engine: engine, ticker: ticker))
    }
}
