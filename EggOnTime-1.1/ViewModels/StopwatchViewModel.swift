//
//  StopwatchViewModel.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import Foundation
import Combine
import SwiftUI

final class Stopwatch: ObservableObject {
    @Published private(set) var wasLaunched = false
    @Published private(set) var isRunning = false
    @Published private(set) var isFinished = false
    
    @Published private(set) var timePassed: TimeInterval = 0.0
    @Published private(set) var timeLeft: TimeInterval { didSet { updatetimeLeftFormatted() } }
    @Published private(set) var timeLeftFormatted: (min: String, sec: String) = ("6", "30")
    
    @Published private(set) var progress = 0.0
    
    /// write the initial moment of starting timer if it was started in JSON
    @AppStorage("timeStartedStored") private var timeStartedStored: Data?
    private var timeStarted: Date? { didSet { updateTimeStartedStored() } }
    
    /// desired time for the timer
    private let timeTimer: TimeInterval
    private var timer: AnyCancellable?
    
    /// calculating idling time since the last pause
    private var timeIdle: TimeInterval = 0.0
    private var momentLastTimePaused: Date?
    
    init(timeTimer: TimeInterval = 20) {
        /// set timerTimer and timerLeft to initialized value, but if not specified, will be 320.0
        self.timeTimer = timeTimer
        timeLeft = self.timeTimer
        
        /// timeStarted fetching data from the timeStartedStored, and if there is a nil - nothing will happen, but if not, stopwatch with start() from the established timeStarted before
        timeStarted = fetchTimeStarted()
        if timeStarted != nil { start() }
    }
}

// MARK: - User Communication
extension Stopwatch {
    func start() {
        timerDeinit()
        wasLaunched = true
        isRunning = true
        /// checking if timer was launched, if so, calculates time from that moment, in not, from current
        if timeStarted == nil { timeStarted = Date() }
        /// checking if timer was paused, if so, calculate time interval since the last stop and add to the timeIdle
        if let pause = momentLastTimePaused {
            let now = Date()
            let elapsed = now.timeIntervalSince(pause)
            timeIdle += elapsed
        }
        /// rund a timer with 0.1 second interval
        timer = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let timeStarted = self.timeStarted else { return }
                /// if timer is finished, stop it
                if !self.isFinished {
                    let now = Date()
                    /// calculate, how much time passes since start was calles subtracting all idle time
                    let elapsed = now.timeIntervalSince(timeStarted) - timeIdle
                    /// every period of time (0.1) updateProperties will be called and update the properties
                    updateProperties(elapsed: elapsed)
                } else {
                    timerDeinit()
                }
            }
        momentLastTimePaused = nil
    }
    
    func pause() {
        timerDeinit()
        isRunning = false
        momentLastTimePaused = Date()
    }
    
    func reset() {
        timerDeinit()
        wasLaunched = false
        isRunning = false
        isFinished = false
        timePassed = 0.0
        timeLeft = timeTimer
        progress = 0.0
        timeStarted = nil
        timeIdle = 0.0
        momentLastTimePaused = nil
    }
}

// MARK: - Private logic
private extension Stopwatch {
    func timerDeinit() {
        timer?.cancel()
        timer = nil
    }
    
    func updatetimeLeftFormatted() {
        let min = Int(timeLeft) / 60
        let sec = Int(timeLeft) % 60
        let secString: String
        if sec < 10 { secString = "0\(sec)" }
        else { secString = String(sec) }
        timeLeftFormatted = (min: String(min), sec: String(secString))
    }
    
    func updateProperties(elapsed: TimeInterval) {
        timePassed = (elapsed * 10).rounded() / 10
        timeLeft = timeTimer - timePassed
        progress = timePassed / timeTimer
        if timePassed >= timeTimer { isFinished = true }
    }
    
    /// encode current moment of timeStarted to timeStartedStored if it exists
    func updateTimeStartedStored() {
        if let timeStarted {
            do {
                timeStartedStored = try JSONEncoder().encode(timeStarted)
            } catch {
                print("Error encoding timeStarted: \(error)")
            }
        } else {
            timeStartedStored = nil
        }
    }
    
    /// decode last initial launch moment from the timeStartedStored to the timeStarted
    func fetchTimeStarted() -> Date? {
        if let timeStartedStored {
            do {
                return try JSONDecoder().decode(Date.self, from: timeStartedStored)
            } catch {
                print("Error decoding timeStartedStored: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
}
