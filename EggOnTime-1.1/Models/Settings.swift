//
//  Settings.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 06/09/2023.
//

import Foundation
import SwiftUI

final class Settings: ObservableObject {
    @Published var isNotificationEnabled: Bool { didSet { UserDefaults.standard.set(isNotificationEnabled, forKey: "isNotificationEnabled") } }
    @Published var isSoundEnabled: Bool { didSet { UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled") } }
    @Published var isVibrationEnabled: Bool { didSet { UserDefaults.standard.set(isVibrationEnabled, forKey: "isVibrationEnabled") } }
    @Published var isDarkModeEnabled: Bool { didSet { UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkModeEnabled") } }
    
    var colorScheme: ColorScheme {
        return isDarkModeEnabled ? .dark : .light
    }
    
    init() { /// usually used like isNotificationEnabled = UserDefaults.standard.bool(forKey: "isNotificationEnabled"), what meand get the boolean value from UserDefault, and if it's empty return false. In my case I cast UserDefault object itself as a Boolean, an if it is, return UD value, but if UD can't be casted, take true as default. That ensures that setting are set to true by default, untill changed
        isNotificationEnabled = UserDefaults.standard.object(forKey: "isNotificationEnabled") as? Bool ?? true
        isSoundEnabled = UserDefaults.standard.object(forKey: "isSoundEnabled") as? Bool ?? true
        isVibrationEnabled = UserDefaults.standard.object(forKey: "isVibrationEnabled") as? Bool ?? true
        isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled") /// !!! here is took direct UD bool value, because Dark Mode should be false by default
    }
}
