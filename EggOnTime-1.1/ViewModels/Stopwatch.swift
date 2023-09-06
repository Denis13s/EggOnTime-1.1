//
//  StopwatchViewModel.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

final class Stopwatch: ObservableObject {
    @Published private(set) var wasLaunched = false
    @Published private(set) var isRunning = false
    @Published private(set) var isFinished = false
    
    @Published private(set) var timePassed: TimeInterval = 0.0
    @Published private(set) var timeLeft: TimeInterval { didSet { updatetimeLeftFormatted() } }
    @Published private(set) var timeLeftFormatted: (min: String, sec: String) = ("6", "30")
    
    @Published private(set) var progress = 0.0
    
    @Published private(set) var shouldAlert = false
    
    @Published private(set) var notificationPermissionStatus = false
    
    /// write the initial moment of starting timer if it was started in JSON
    @AppStorage("timeStartedStored") private var timeStartedStored: Data?
    private var timeStarted: Date? { didSet { updateTimeStartedStored() } }
    
    /// desired time for the timer
    //private let timeTimer: TimeInterval
    var timeTimer: TimeInterval
    private let timeAlert: TimeInterval
    private var timer: AnyCancellable?
    
    /// calculating idling time since the last pause
    private var timeIdle: TimeInterval = 0.0
    private var momentLastTimePaused: Date?
    
    init(timeTimer: TimeInterval = 60, timeAlert: TimeInterval) {
        /// set timerTimer and timerLeft to initialized value, but if not specified, will be 320.0
        self.timeTimer = timeTimer
        timeLeft = self.timeTimer
        self.timeAlert = timeAlert
        
        /// timeStarted fetching data from the timeStartedStored, and if there is a nil - nothing will happen, but if not, stopwatch with start() from the established timeStarted before
        timeStarted = fetchTimeStarted()
        if timeStarted != nil { start() }
        
        /// ensuring that the formatted time is already updated by the time it's called
        updatetimeLeftFormatted()
    }
}

// MARK: - Notifications
extension Stopwatch {
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: .alert) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.notificationPermissionStatus = true
                } else {
                    self.notificationPermissionStatus = false
                }
            }
        }
    }
    
    func scheduleNotifications() {
        deinitNotifications()
        
        let now = Date()
        // MARK: - # REPLACE
        let dateStarted = now + 5
        let dateReady = now + 10
        let dateAlmostReady = dateReady - 2
        /*
         MARK: - ORIGINAL CODE
         let dateStarted = now + 5
         let dateReady = now + timeTimer
         let dateAlmostReady = dateReady - timeAlert
        */
        
        createNotification(
            title: "Boiling initiated",
            body: "Egg ready in \(timeLeftFormatted.min):\(timeLeftFormatted.sec)",
            date: dateStarted)
        
        
        createNotification(
            title: "Almost ready",
            body: "Egg done in \(Int(timeAlert)) seconds",
            date: dateAlmostReady)
        
        
        createNotification(
            title: "Done",
            body: "Egg is ready to eat. Enjoy your meal!",
            date: dateReady)
    }
    
    func rescheduleNotifications() {
        deinitNotifications()
        
        if let timeStarted {
            // MARK: - # REPLACE
            var now = timeStarted
            now = Date()
            let dateReady = now + 10
            let dateAlmostReady = dateReady - 2
            /*
             MARK: - ORIGINAL CODE
             let dateReady = timeStarted + timeTimer + timeIdle
             let dateAlmostReady = dateReady - timeAlert
            */
            
            createNotification(
                title: "Almost ready",
                body: "Egg done in \(Int(timeAlert)) seconds",
                date: dateAlmostReady)
            
            createNotification(
                title: "Done",
                body: "Egg is ready to eat. Enjoy your meal!",
                date: dateReady)
        }
    }
    
    func createNotification(title: String, body: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.sound = nil
        content.title = title
        content.body = body
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func deinitNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
}

// MARK: - User Communication
extension Stopwatch {
    func start() {
        deinitTimer()
        wasLaunched = true
        isRunning = true
        /// checking if timer was launched, if so, calculates time from that moment, in not, from current
        if timeStarted == nil {
            timeStarted = Date()
        }
        /// checking if timer was paused, if so, calculate time interval since the last stop and add to the timeIdle
        if let pause = momentLastTimePaused {
            let now = Date()
            let elapsed = now.timeIntervalSince(pause)
            timeIdle += elapsed
            rescheduleNotifications()
        }
        /// rund a timer with 0.1 second interval
        timer = Timer
        /// previously time interval was 0.1, but I tried to make 1.0. Maybe could increase performance .publish(every: 0.1, on: .main, in: .common)
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let timeStarted = self.timeStarted else { return }
                /// if timer is finished, stop it
                if !self.isFinished {
                    let now = Date()
                    /// calculate, how much time passes since start was calles subtracting all idle time
                    let elapsed = now.timeIntervalSince(timeStarted) - timeIdle
                    
                    // MARK: - # REPLACE
                    let elapsedSpeededUP = elapsed * 10
                    updateProperties(elapsed: elapsedSpeededUP)
                    /*
                    // MARK: Original code
                    /// every period of time (0.1) updateProperties will be called and update the properties
                    updateProperties(elapsed: elapsed)
                    */
                    
                } else {
                    /// making sure, that is timer is finished, all the values get default values. this prevents from getting negative time
                    deinitTimer()
                    wasLaunched = true
                    isRunning = false
                    isFinished = true
                    timeLeft = 0.0
                    progress = 1.0
                    shouldAlert = false
                    deinitNotifications()
                }
            }
        momentLastTimePaused = nil
    }
    
    func pause() {
        deinitTimer()
        isRunning = false
        momentLastTimePaused = Date()
    }
    
    func reset() {
        deinitTimer()
        wasLaunched = false
        isRunning = false
        isFinished = false
        timePassed = 0.0
        timeLeft = timeTimer
        progress = 0.0
        shouldAlert = false
        timeStarted = nil
        timeIdle = 0.0
        momentLastTimePaused = nil
        deinitNotifications()
    }
}

// MARK: - Private logic
private extension Stopwatch {
    func deinitTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func updatetimeLeftFormatted() {
        /// ensuring that timeLeftFormatted will newer show begative values
        guard timeLeft >= 0 else {
            timeLeftFormatted = (min: "0", sec: "00")
            return
        }
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
        if timeLeft <= timeAlert { shouldAlert = true }
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
