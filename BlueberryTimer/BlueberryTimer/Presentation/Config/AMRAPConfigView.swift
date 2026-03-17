//
//  AMRAPConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 3/9/26.
//

import SwiftUI

struct AMRAPConfigView: View {
    @State private var minutesText: String = "12"
    
    private var totalMinutes: Int {
        Int(minutesText) ?? 0
    }
    
    var body: some View {
        Form {
            Section("Time Cap") {
                TextField("Minutes", text: $minutesText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            Section {
                //this navigation link is the action
                NavigationLink {
                    //Here is where I give some useful information to the Timer be created.
                    let config = TimerConfig.amrap(totalMinutes: max(1, totalMinutes))
                    let engine = TimerEngine(config: config)
                    let ticker = SystemTicker()
                    
                    TimerView(viewModel: TimerViewModel(
                        engine: engine,
                        ticker: ticker)
                    )
                    
                } label: {
                    Text("Start Amrap")
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle("AMRAP Setup")
    }
}

#Preview {
    AMRAPConfigView()
}
