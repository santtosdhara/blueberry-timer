//
//  TimerEngineProtocol.swift
//  BlueberryTimer
//
//  Created by Dhara Chavez on 2/19/26.
//

import Foundation

protocol TimerEngineProtocol: AnyObject {
    
    var state: TimerState { get }
    
    //MARK: - Lyfecycle
    
    func start()
    func pause()
    func reset()
    
    //MARK: - Time progression
    func tick()
}
