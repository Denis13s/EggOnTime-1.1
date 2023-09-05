//
//  CircleBGView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI
import Foundation

struct CircleBGView: View {
    
    @EnvironmentObject var stopwatch: Stopwatch
    @EnvironmentObject var screen: Screen
    
    @State private var opacityCircle = 0.0
    @State private var trimValue = 1.0 /// trimValue to 1.0 means that the progress of bar is zero. Progress increates when value goes down
    @State private var angle: Double = 0.0
    
    let height: CGFloat
    private var diameter: CGFloat { height * 2 }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Circle() /// BG circle
                    .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                    .frame(width: diameter, height: diameter)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).minY - screen.paddingVBig
                    )
                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                
                Circle() /// flashing circle
                    .foregroundColor(MyColor.four)
                    .opacity(opacityCircle)
                    .frame(width: diameter, height: diameter)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).minY - screen.paddingVBig
                    )
                
                Circle() /// BG Progress
                    .trim(from: 1.0 - (angle / 360.0), to: 1)
                    .stroke(style: StrokeStyle(lineWidth: screen.paddingVSmall / 4, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 90.0 + angle / 2))
                    .frame(width: diameter, height: diameter)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).minY
                    )
                    .foregroundColor(MyColor.three)
                
                Circle() /// Progress bar
                    .trim(from: 1.0 - (trimValue / 360.0), to: 1)
                    .stroke(style: StrokeStyle(lineWidth: screen.paddingVSmall / 4, lineCap: .round, lineJoin: .round))
                    .fill(LinearGradient(colors: [MyColor.two, MyColor.four], startPoint: .center, endPoint: .top))
                    .rotationEffect(Angle(degrees: 90.0 + angle / 2))
                    .frame(width: diameter, height: diameter)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).minY
                    )
                
                
            }
            .onAppear {
                angle = Double((360 * asin(screen.width / (diameter + screen.height * 0.2)) / CGFloat.pi))
            }
            .onChange(of: stopwatch.shouldAlert) { newValue in
                if newValue { withAnimation(.easeOut(duration: 1).repeatForever()) { opacityCircle = 0.5 } }
                else { withAnimation { opacityCircle = 0.0 } }
            }
            .onChange(of: stopwatch.timePassed) { _ in
                withAnimation {
                    trimValue = 1.0 - (angle * stopwatch.progress / 360.0)
                }
            }
        }
        .ignoresSafeArea()
        
        
        
        // var body
    }
}

struct CircleBGView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return CircleBGView(height: 605)
            .environmentObject(Stopwatch(timeTimer: 100, timeAlert: 20))
            .environmentObject(screen)
    }
}
