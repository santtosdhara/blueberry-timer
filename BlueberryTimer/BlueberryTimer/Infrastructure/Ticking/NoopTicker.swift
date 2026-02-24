//
//  NoopTicker.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/24/26.
//

import Foundation

final class NoopTicker: Ticker {
    func start(every interval: TimeInterval, _ onTick: @escaping () -> Void) { }
    func stop() { }
}
