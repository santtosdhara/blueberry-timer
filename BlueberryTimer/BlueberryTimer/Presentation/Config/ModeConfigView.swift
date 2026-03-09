//
//  ModeConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import SwiftUI

struct ModeConfigView: View {
    let mode: TimerMode
    
    var body: some View {
        switch mode {
        case .emom:
            EMOMConfigView()
        case .amrap:
            AMRAPConfigView()
        case .forTime, .tabata:
            Text("\(mode.rawValue) coming soon")
                .font(.title3)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}
