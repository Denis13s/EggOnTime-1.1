//
//  ContentView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

/*
 MARK: Features
 - EggOnTime_App: setting timeStartedStored (Stopwatch property) to nil every time the app is relaunched
 - Target - EggOnTime: added Privacy - User Notifications Usage Description - Stay updated on your egg's progress with instant reminders
 - Target: Only Iphone with portrait orientation
 
 TODO:
 - !!! Replace original timing in CookingViewModel
 */

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var model: CookingViewModel
    @EnvironmentObject var screen: Screen
    @EnvironmentObject var settings: Settings
    
    @State var isCookingViewPresented = false
    @State var isOnboardingViewPresented = false
    @State var isSideMenuViewPresented = false
    
    var body: some View {
        @AppStorage("hasShownOnboardingView") var hasShownOnboardingView: Bool = false
        
            ZStack {
                Rectangle()
                    .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Preview
                    GeometryReader { geometry in
                        EggMainView(height: geometry.size.height)
                    }
                    .padding(.top, screen.paddingVBig)
                    
                    // MARK: - Parameters
                    VStack(spacing: screen.paddingVSmall) {
                        SelectingParameterView(title: "Size", parameter: EggSize.m, barHeight: screen.paddingVSmall * 2)
                        SelectingParameterView(title: "Temperature", parameter: EggTemp.refrigerated, barHeight: screen.paddingVSmall * 2)
                        SelectingParameterView(title: "Condition", parameter: EggCondition.medium, barHeight: screen.paddingVSmall * 2)
                    }
                    .padding(.top, screen.paddingVSmall)
                    
                    // MARK: - Divider
                    DividerView()
                        .padding(.top, screen.paddingVBig)
                    
                    // MARK: - Start Button
                    Button { isCookingViewPresented.toggle() } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: screen.height * 0.04)
                                .frame(width: screen.width * 0.3, height: screen.height * 0.08)
                                .foregroundColor(MyColor.four)
                            Text("Start")
                                .font(.system(size: screen.fontTitle3))
                                .fontWeight(.medium)
                                .foregroundColor(MyColor.three)
                        }
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                    }
                    .padding(.top, screen.paddingVBig)
                }
                .padding(.horizontal, screen.paddingHBig)
                .padding(.bottom, screen.paddingVSmall)
                
                // MARK: - Top buttons
                VStack {
                    HStack {
                        Button { isOnboardingViewPresented.toggle() } label: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: screen.paddingVBig * 0.8)
                        }
                        Spacer()
                        
                        Button { isSideMenuViewPresented.toggle() } label: {
                            Image(systemName: "gearshape.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: screen.paddingVBig  * 0.8)
                        }
                    }
                    .foregroundColor(MyColor.four.opacity(0.5))
                    
                    Spacer()
                }
                .padding(.vertical, screen.paddingVSmall)
                .padding(.horizontal, screen.paddingHSmall)
                
                // MARK: - Side Menu
                SideMenuView(isSideMenuViewPresented: $isSideMenuViewPresented)
            }
            .onAppear {
                if !hasShownOnboardingView { isOnboardingViewPresented = true }
            }
            .fullScreenCover(isPresented: $isCookingViewPresented) {
                CookingView(isCookingViewPresented: $isCookingViewPresented)
                    .environmentObject(Stopwatch(timeTimer: model.timeCooking.all, timeAlert: 20))
            }
            .fullScreenCover(isPresented: $isOnboardingViewPresented) {
                OnboardingView(isOnboardingViewPresented: $isOnboardingViewPresented)
            }
        
        .environment(\.colorScheme, settings.colorScheme) /// DarkMode enabling
        
        // var body
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(CookingViewModel())
            .environmentObject(Stopwatch(timeAlert: 20))
            .environmentObject(Screen())
            .environmentObject(Settings())
    }
}
