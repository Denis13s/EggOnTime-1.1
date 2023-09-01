//
//  EggOnTime_1_1App.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

@main
struct EggOnTime_1_1App: App {
    
    /// ensuring that the UserDefault timeStartedStored is cleared every time app is Relaunched
    init() {
        UserDefaults.standard.set(nil, forKey: "timeStartedStored")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(Stopwatch())
        }
    }
}
