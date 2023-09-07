//
//  OnboardingView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 07/09/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var screen: Screen
    @EnvironmentObject var settings: Settings
    
    @Binding var isOnboardingViewPresented: Bool
    
    let onboardings = [
        (
            image: "welcome",
            title: "Welcome to EggOnTime!",
            description: "Perfectly boiled eggs made easy"
        ),
        (
            image: "customization",
            title: "Egg Customization",
            description: "Select your egg's size and temperature. Adjust its condition and see a live preview"
        ),
        (
            image: "timing",
            title: "Precision Timing",
            description: " Begin boiling, see the egg change live, and pick when it's perfect for you"
        ),
        (
            image: "alerts",
            title: "Timely Alerts",
            description: "Get timely alerts for key moments. Never overcook or forget your egg again"
        ),
        (
            image: "settings",
            title: "Personalized Settings",
            description: "Customize your experience in settings. From dark mode to vibrations, set it just the way you like"
        )
    ]
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                .ignoresSafeArea()
            
            TabView {
                ForEach(0...onboardings.count-1, id: \.self) { index in
                    OnboardView(
                        isOnboardingViewPresented: $isOnboardingViewPresented,
                        image: onboardings[index].image,
                        title: onboardings[index].title,
                        description: onboardings[index].description,
                        tag: index,
                        count: onboardings.count
                    )
                }
            }
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .environment(\.colorScheme, settings.colorScheme) /// DarkMode enabling
        
        // var body
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return OnboardingView(isOnboardingViewPresented: Binding.constant(true))
            .environmentObject(screen)
            .environmentObject(Settings())
    }
}
