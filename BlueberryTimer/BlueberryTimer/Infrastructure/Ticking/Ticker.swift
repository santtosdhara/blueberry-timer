//
//  Ticker.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import Foundation

/// Infrastructure clock abstraction.
/// - Why: Time is an external dependency. Abstracting it enables deterministic tests (fake ticker)
///   and keeps Domain free of scheduling concerns.

protocol Ticker: AnyObject {
    func start(every interval: TimeInterval, _ onTick: @escaping () -> Void)
    func stop()
}

