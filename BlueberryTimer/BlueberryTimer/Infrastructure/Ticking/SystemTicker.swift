//
//  SystemTicker.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import Foundation

final class SystemTicker: Ticker {
    private var timer: Timer?
    
    func start(every interval: TimeInterval = 1.0, _ onTick: @escaping () -> Void) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            onTick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
