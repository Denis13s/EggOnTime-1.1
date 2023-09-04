//
//  CookingViewModel.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import Foundation

final class CookingViewModel: ObservableObject {
    @Published var eggSize = EggSize.m { didSet { calculateTime() } }
    @Published var eggTemp = EggTemp.refrigerated { didSet { calculateTime() } }
    @Published var eggCondition = EggCondition.medium { didSet { calculateTime() } }
    
    @Published private(set) var timeCooking: (all: Double, soft: Double, medium: Double, hard: Double) = (390.0, 270.0, 390.0, 630.0) { didSet { updateTimeFormatted() } }
    @Published private(set) var timeFormatted: (min: String, sec: String) = ("6", "30")
}

// MARK: - Calculating time
private extension CookingViewModel {
    func updateTimeFormatted() {
        let min = Int(timeCooking.all) / 60
        let sec = Int(timeCooking.all) % 60
        let secString: String
        if sec < 10 { secString = "0\(sec)" }
        else { secString = String(sec) }
        timeFormatted = (min: String(min), sec: String(secString))
    }
    
    func calculateTime() {
        let timeBase: (soft: Double, medium: Double, hard: Double)
        switch eggTemp {
        case .refrigerated: timeBase = (soft: 270.0, medium: 390.0, hard: 630.0)
        case .room: timeBase = (soft: 210.0, medium: 330.0, hard: 540.0)
        }
        
        let sizeAdjustment: Double
        switch eggSize {
        case .s: sizeAdjustment = -60.0
        case .m: sizeAdjustment = 0.0
        case .l: sizeAdjustment = 60.0
        case .xl: sizeAdjustment = 120.0
        }
        
        let selectedTime: Double
        switch eggCondition {
        case .soft: selectedTime = timeBase.soft
        case .medium: selectedTime = timeBase.medium
        case .hard: selectedTime = timeBase.hard
        }
        
        timeCooking = (
            all: selectedTime + sizeAdjustment,
            soft: timeBase.soft + sizeAdjustment,
            medium: timeBase.medium + sizeAdjustment,
            hard: timeBase.hard + sizeAdjustment
        )
    }
}

