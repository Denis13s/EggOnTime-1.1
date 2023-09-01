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
    
    @State var width: CGFloat
    @State var height: CGFloat
    @State var offset: Double
    
    @State private var opacityCircle = 0.0
    
    var body: some View {
        
        GeometryReader { geometry in
            let angle = Double((360 * asin(geometry.size.width / (width * 2)) / CGFloat.pi / offset))
            
            
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: 600))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: width * 2)
                    .position(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2 - 20
                        )
                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                
                // MARK: - Flashing circle
//                Circle()
//                    .foregroundColor(MyColor.four)
//                    .opacity(opacityCircle)
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: width * 2)
//                    .position(
//                        x: geometry.frame(in: .global).midX,
//                        y: geometry.frame(in: .global).midY + (geometry.frame(in: .global).maxY - width * 2) / 2 - 20
//                        )
//                    .onChange(of: timer.shouldHurryUp) { newValue in
//                        if newValue { withAnimation(.easeOut(duration: 1).repeatForever()) { opacityCircle = 0.5 } }
//                        else { withAnimation { opacityCircle = 0.0 } }
//                    }
                
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
                    .trim(from: 1.0 - (angle * stopwatch.progress / 360.0), to: 1)
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
        }
        .ignoresSafeArea()
        
        // var body
    }
}

struct CircleBGView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.gray)
            
            CircleBGView(width: 393, height: 759, offset: 1.1)
                .environmentObject(Stopwatch(timeTimer: 100))
        }
    }
}
