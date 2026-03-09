//
//  TimeDisplay.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import SwiftUI

struct TimeDisplay: View {
    let remainingSeconds: Int
    
    var body: some View {
        Text(format(seconds: remainingSeconds))
            .font(.system(size: 64, weight: .bold, design: .rounded))
            .monospacedDigit()
    }
    
    private func format(seconds: Int) -> String {
          let m = max(0, seconds) / 60
          let s = max(0, seconds) % 60
          return String(format: "%02d:%02d", m, s)
      }
}

#Preview {
    TimeDisplay(remainingSeconds: 9 * 60 + 12)
        .padding()
}
