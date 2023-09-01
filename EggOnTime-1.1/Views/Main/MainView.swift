//
//  ContentView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

/*
 - EggOnTime_App: setting timeStartedStored (Stopwatch property) to nil every time the app is relaunched 
 */

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var stopwatch: Stopwatch
    
    var body: some View {
        
        VStack {
            Image("egg-medium")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Time passed: \(String(format: "%.1f", stopwatch.timePassed))")
            Text("isRunning: \(String(stopwatch.isRunning))")
            Text("Time left: \(String(format: "%.1f", stopwatch.timeLeft))")
            Text("Progress: \(stopwatch.progress)")
            
   
                if !stopwatch.wasLaunched {
                    Button {
                        stopwatch.start()
                    } label: {
                        Text("Start")
                    }
                } else {
                    if !stopwatch.isFinished {
                        HStack {
                            Button {
                                stopwatch.isRunning ?  stopwatch.pause() : stopwatch.start()
                            } label: {
                                Text(stopwatch.isRunning ? "Pause": "Countinue")
                            }
                            
                            Button {
                                stopwatch.reset()
                            } label: {
                                Text("Reset")
                            }
                        }
                    } else {
                        Button {
                            stopwatch.reset()
                        } label: {
                            Text("Reset")
                        }
                    }
                }
                
                
                
           
        }
        
        // var body
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Stopwatch())
    }
}
