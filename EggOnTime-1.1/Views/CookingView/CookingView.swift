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
    @EnvironmentObject var screen: Screen
    
    @Binding var isCookingViewPresented: Bool
    
    @State var currentEggCondition = "Raw"
    
    @State private var opacityButton1 = 1.0
    @State private var opacityButton2 = 0.0
    
    var body: some View {
        
        ZStack {
            // MARK: - BG
            Rectangle()
                .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
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
                                    .frame(height: screen.paddingVBig)
                            }
                        }
                        .foregroundColor(MyColor.four.opacity(0.5))
                        .padding(.horizontal, screen.paddingHSmall)
                        .padding(.vertical, screen.paddingVSmall)
                        
                        // MARK: - Egg Condition
                        VStack(spacing: 0) {
                            ZStack {
                                RoundedRectangle(cornerRadius: screen.paddingVSmall)
                                    .foregroundColor(MyColor.four)
                                    .frame(width: screen.width * 0.3, height: screen.paddingVSmall * 2)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text(currentEggCondition)
                                    .font(.system(size: screen.fontCallout))
                                    .foregroundColor(MyColor.three)
                                    .fontWeight(.light)
                            }
                            .padding(.bottom, screen.paddingVSmall / 2)
                            
                            Text("Current Condition")
                                .font(.system(size: screen.fontCaption))
                                .fontWeight(.light)
                                .foregroundColor(MyColor.four)
                        }
                        .padding(.horizontal, screen.paddingHBig)
                        
                        EggCookingView()
                            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                            .padding(.horizontal, screen.paddingHBig)
                            .padding(.vertical, screen.paddingVBig)
                    }
                }
                
                Group {
                    // MARK: - Time left
                    VStack(spacing: 0) {
                        Text(stopwatch.timeLeftFormatted.min + ":" + stopwatch.timeLeftFormatted.sec)
                            .font(.system(size: screen.fontXLarge))
                            .fontWeight(.bold)
                        
                        Text("Time Remaining")
                            .font(.system(size: screen.fontCallout))
                            .fontWeight(.light)
                    }
                    .foregroundColor(MyColor.four)
                    .padding(.top, screen.paddingVSmall)
                    
                    // MARK: - Divider
                    DividerView()
                        .padding(.top, screen.paddingVBig)
                    
                    // MARK: - Timer buttons
                    HStack(spacing: screen.paddingHBig * 2) {
                        
                        if !stopwatch.isFinished {
                            Group {
                                Button { stopwatch.reset() } label: {
                                    CircleButtonView(color: MyColor.two, imageColor: MyColor.four, image: "arrow.counterclockwise")
                                }
                                
                                Button {
                                    if stopwatch.isRunning { stopwatch.pause() }
                                    else { stopwatch.start() }
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
                                Button { stopwatch.reset() } label: {
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
                    .padding(.top, screen.paddingVBig)
                }
                .padding(.horizontal, screen.paddingHBig)
            }
            .padding(.bottom, screen.paddingVSmall)
        }
        // Start timer and schedule notification once the View appeared
        .onAppear {
            stopwatch.start()
            if !stopwatch.notificationPermissionStatus { stopwatch.requestNotificationPermission() }
        }
        .onChange(of: stopwatch.shouldAlert) { newValue in
            if newValue {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) /// Vibration
                AudioServicesPlaySystemSound(1060)
            }
        }
        .onChange(of: stopwatch.isFinished) { newValue in
            if newValue {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) /// Vibration
                AudioServicesPlaySystemSound(1026)
                
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
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return CookingView(isCookingViewPresented: Binding.constant(true))
                    .environmentObject(CookingViewModel())
                    .environmentObject(Stopwatch(timeAlert: 20))
                    .environmentObject(screen)
    }
}

