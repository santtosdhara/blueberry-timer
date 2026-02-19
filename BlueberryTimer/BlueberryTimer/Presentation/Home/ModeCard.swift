//
//  ModeCard.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import SwiftUI

struct ModeCard: View {
    let mode: TimerMode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mode.rawValue)
                .font(.headline)

            Text(mode.shortDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ModeCard(mode: .emom)
        .padding()
}
