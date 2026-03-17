//
//  ForTimeConfigView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 3/11/26.
//

import SwiftUI

struct ForTimeConfigView: View {
    @State private var minutesText: String = "12"
    
    private var totalMinutes: Int {
        Int(minutesText) ?? 0
    }
    var body: some View {
        Form {
            Section("Time Cap") {
                TextField("minutes", text: $minutesText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    ForTimeConfigView()
}
