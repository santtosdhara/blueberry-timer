//
//  HomeView.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(TimerMode.allCases) { mode in
                        NavigationLink(value: mode) {
                            ModeCard(mode: mode)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
            .navigationTitle("Blueberry Timer")
            .navigationDestination(for: TimerMode.self) { mode in
                Text("\(mode.rawValue) Config")
                    .font(.title)
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
