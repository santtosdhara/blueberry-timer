//
//  Ticker.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/23/26.
//

import Foundation

protocol Ticker: AnyObject {
    func start(every interval: TimeInterval, _ onTick: @escaping () -> Void)
    func stop()
}

