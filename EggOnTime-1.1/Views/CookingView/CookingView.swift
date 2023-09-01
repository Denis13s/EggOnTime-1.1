//
//  CookingView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI
import AudioToolbox

struct CookingView: View {
    
    @EnvironmentObject var model: CookingViewModel
    @EnvironmentObject var stopwatch: Stopwatch
    
    @Binding var isCookingViewPresented: Bool
    
    @State var currentEggCondition = "Raw"
    
    @State private var opacityButton1 = 1.0
    @State private var opacityButton2 = 0.0
    
    var body: some View {
        
        // MARK: - Vibration module
//        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        
        ZStack {
            // MARK: - BG
            Rectangle()
                .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: 600))
                .ignoresSafeArea()
            
            // MARK: - UI
            VStack(spacing: 0) {
                ZStack {
                    GeometryReader { geometry in
                        CircleBGView(width: geometry.size.width, height: geometry.size.height, offset: 1.1)
                    }
                    .ignoresSafeArea()
                    
                    
                    VStack(spacing: 0) {
                        // MARK: - Top button
                        HStack {
                            Spacer()
                            
                            Button {
                                isCookingViewPresented.toggle()
                                stopwatch.reset()
                            } label: {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                            }
                        }
                        .foregroundColor(MyColor.four.opacity(0.5))
                        .padding()
                        
                        // MARK: - Egg Condition
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(MyColor.four)
                                    .frame(width: 120, height: 40)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text(currentEggCondition)
                                    .font(.callout)
                                    .foregroundColor(MyColor.three)
                                    .fontWeight(.light)
                            }
                            Text("Current Condition")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(MyColor.four)
                        }
                        .padding(.vertical, 35)
                        
                        EggCookingView()
                            .padding(35)
                            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                    }
                }
                
                
                
                Group {
                    
                    // MARK: - Time left
                    VStack(spacing: 0) {
                        Text(stopwatch.timeLeftFormatted.min + ":" + stopwatch.timeLeftFormatted.sec)
                            .font(.system(size: 86))
                            .fontWeight(.bold)
                        
                        Text("Time Remaining")
                            .fontWeight(.light)
                    }
                    .foregroundColor(MyColor.four)
                    .padding(.top, 35)
                    
                    // MARK: - Divider
                    DividerView()
                        .padding(.top, 35)
                    
                    // MARK: - Timer buttons
                    HStack(spacing: 70) {
                        
                        if !stopwatch.isFinished {
                            Group {
                                Button {
                                    stopwatch.reset()
                                } label: {
                                    CircleButtonView(color: MyColor.two, imageColor: MyColor.four, image: "arrow.counterclockwise")
                                    
                                }
                                
                                Button {
                                    if stopwatch.isRunning {
                                        stopwatch.pause()
                                    }
                                    else {
                                        stopwatch.start()
                                    }
                                } label: {
                                    if stopwatch.isRunning {
                                        CircleButtonView(
                                            color: MyColor.four,
                                            imageColor: MyColor.three,
                                            image: "pause")
                                    }
                                    else {
                                        CircleButtonView(
                                            color: MyColor.four,
                                            imageColor: MyColor.three,
                                            image: "play")
                                    }
                                }
                            }
                            .opacity(opacityButton1)
                        }
                        else {
                            Group {
                                Button {
                                    stopwatch.reset()
                                } label: {
                                    CircleButtonView(color: MyColor.two, imageColor: MyColor.four, image: "arrow.counterclockwise")
                                }
                                
                                Button {
                                    isCookingViewPresented.toggle()
                                    stopwatch.reset()
                                } label: {
                                    CircleButtonView(color: MyColor.four, imageColor: MyColor.three, image: "xmark")
                                }
                            }
                            .opacity(opacityButton2)
                        }
                        
                        
                        
                        
                        
                    }
                    .padding(.vertical, 35)
                }
                .padding(.horizontal, 35)
            }
            
            
        }
        // Start timer and schedule notification once the View appeared
        .onAppear {
            stopwatch.start()
//            model.scheduleNotification(type: .started)
        }
//        .onChange(of: timer.shouldHurryUp) { newValue in
//            if newValue {
//                AudioServicesPlaySystemSound(1060)
//                feedbackGenerator.impactOccurred()
//                model.scheduleNotification(type: .almostReady)
//            }
//        }
        .onChange(of: stopwatch.isFinished) { newValue in
            if newValue {
                AudioServicesPlaySystemSound(1026)
//                model.scheduleNotification(type: .ready)
                
                // Animation for the buttons fading
                withAnimation {
                    opacityButton1 = 0.0
                    opacityButton2 = 1.0
                }
            } else {
                withAnimation {
                    opacityButton1 = 1.0
                    opacityButton2 = 0.0
                }
            }
        }
        .onChange(of: stopwatch.timePassed) { newValue in
            withAnimation(.easeInOut(duration: 2)) {
                switch newValue {
                case ..<model.timeCooking.soft: currentEggCondition = "Raw"
                case model.timeCooking.soft..<model.timeCooking.medium: currentEggCondition = EggCondition.soft.rawValue
                case model.timeCooking.medium..<model.timeCooking.hard: currentEggCondition = EggCondition.medium.rawValue
                case model.timeCooking.hard...: currentEggCondition = EggCondition.hard.rawValue
                default: currentEggCondition = "Raw"
                }
            }
        }
        
        // var body
    }
}

struct CookingView_Previews: PreviewProvider {
    static var previews: some View {
        CookingView(isCookingViewPresented: Binding.constant(true))
            .environmentObject(CookingViewModel())
            .environmentObject(Stopwatch())
    }
}