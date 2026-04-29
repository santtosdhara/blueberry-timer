//
//  TabataConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 3/25/26.
//

import SwiftUI

struct TabataConfigView: View {
    @State private var workSecondsText: String = "20"
    @State private var restSecondsText: String = "10"
    @State private var roundsText: String = "8"
    
    
    private var workSeconds: Int { Int(workSecondsText) ?? 0 }
    private var restSeconds: Int { Int(restSecondsText) ?? 0 }
    private var rounds: Int { Int(roundsText) ?? 0 }
    
    
    var body: some View {
        Form {
            Section("Work Time") {
                TextField("timecap", text: $workSecondsText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            Section("Rest Time") {
                TextField("timecap", text: $restSecondsText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            Section("Rounds") {
                TextField("timecap", text: $roundsText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            
            Section {
                NavigationLink {
                    let config = TimerConfig.tabata(workSeconds: workSeconds, restSeconds: restSeconds, rounds: rounds)
                    let engine = TimerEngine(config: config)
                    let ticker = SystemTicker()
                    
                    TimerView(viewModel: TimerViewModel(
                        engine: engine,
                        ticker: ticker)
                    )
                } label: {
                    Text("Start ForTime Workout")
                        .fontWeight(.bold)
                }
            }
        }
        .navigationTitle("Tabata Setup")
    }
}


#Preview {
    TabataConfigView()
}
