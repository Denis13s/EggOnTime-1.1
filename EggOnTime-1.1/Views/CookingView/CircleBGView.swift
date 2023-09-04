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
    
    let width: CGFloat
    let height: CGFloat
    let offset: Double
    
    @State private var opacityCircle = 0.0
    /// trimValue to 1.0 means that the progress of bar is zero. Progress increates when value goes down
    @State private var trimValue = 1.0
    @State private var angle: Double = 0.0
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: width * 2)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2 - 20
                    )
                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                
                // MARK: - Flashing circle
                Circle()
                    .foregroundColor(MyColor.four)
                    .opacity(opacityCircle)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: width * 2)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2 - 20
                    )
                    .onChange(of: stopwatch.shouldAlert) { newValue in
                        if newValue { withAnimation(.easeOut(duration: 1).repeatForever()) { opacityCircle = 0.5 } }
                        else { withAnimation { opacityCircle = 0.0 } }
                    }
                
                // BG bar
                Circle()
                    .trim(from: 1.0 - (angle / 360.0), to: 1)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 90.0 + angle / 2))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: width * 2)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2
                    )
                    .foregroundColor(MyColor.three)
                
                // Actual progress for bar
                Circle()
                    .trim(from: trimValue, to: 1)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .fill(LinearGradient(colors: [MyColor.two, MyColor.four], startPoint: .center, endPoint: .top))
                    .rotationEffect(Angle(degrees: 90.0 + angle / 2))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: width * 2)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2
                    )
            }
            .onAppear {
                angle = Double((360 * asin(geometry.size.width / (width * 2)) / CGFloat.pi / offset))
            }
        }
        .ignoresSafeArea()
        .onChange(of: stopwatch.timePassed) { _ in
            withAnimation {
                trimValue = 1.0 - (angle * stopwatch.progress / 360.0)
            }
        }
        
        // var body
    }
}

struct CircleBGView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return CircleBGView(width: 430, height: 839, offset: 1.1)
            .environmentObject(Stopwatch(timeTimer: 100, timeAlert: 20))
            .environmentObject(screen)
        
    }
}
