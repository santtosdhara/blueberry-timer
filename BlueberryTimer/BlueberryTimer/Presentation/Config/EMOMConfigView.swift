//
//  EMOMConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import SwiftUI

struct EMOMConfigView: View {
    @State private var intervalMinutes: Int = 1
    @State private var rounds: Int = 10
    
    var body: some View {
        Form {
            Section("Interval") {
                Stepper("Interval Minutes: \(intervalMinutes)", value: $intervalMinutes, in: 1...20)
            }

            Section("Rounds") {
                Stepper("Rounds: \(rounds)", value: $rounds, in: 1...60)
            }
            
            Section {
                NavigationLink {
                    let config = TimerConfig.emom(intervalMinutes: intervalMinutes, rounds: rounds)
                    let engine = TimerEngine(config: config)
                    let ticker = SystemTicker()
                    TimerView(viewModel: TimerViewModel(engine: engine, ticker: ticker))
                } label : {
                    Text("Start EMOM")
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("EMOM Setup")
        }
    }
}

#Preview {
    EMOMConfigView()
}
