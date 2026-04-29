//
//  AMRAPConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 3/9/26.
//

import SwiftUI

struct AMRAPConfigView: View {
  @State private var viewModel = AMRAPConfigViewModel()
    
    var body: some View {
        Form {
            Section("Time Cap") {
                TextField("Minutes", text: $viewModel.minutesText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            Section {
              
                NavigationLink {
                    TimerView(viewModel: viewModel.makeTimerViewModel())
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
