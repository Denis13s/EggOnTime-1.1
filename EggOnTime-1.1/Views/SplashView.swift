//
//  SplashView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 08/09/2023.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var screen: Screen
    @EnvironmentObject var settings: Settings
    
    @State private var hasShownSplashView: Bool = false
    @State private var scale = 0.8
    @State private var opacity = 0.5
    
    let animationTime: Double = 1.0
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Rectangle().opacity(0)
                    .onAppear {
                        screen.updateSizes(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                
                if hasShownSplashView {
                    MainView()
                }
                else {
                    ZStack {
                        Rectangle()
                            .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.width * 0.9))
                            .ignoresSafeArea()
                        
                        Image("appstore")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screen.width * 0.5, height: screen.width * 0.5)
                            .cornerRadius(screen.width * 0.1)
                            .scaleEffect(scale)
                            .opacity(opacity)
                    }
                    .onAppear {
                        withAnimation(.easeInOut (duration: animationTime)) {
                            scale = 1.0
                            opacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation { hasShownSplashView = true }
                        }
                    }
                    .environment(\.colorScheme, settings.colorScheme) /// DarkMode enabling
                }
            }
        }
        
        // var body
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return SplashView()
            .environmentObject(CookingViewModel())
            .environmentObject(Stopwatch(timeAlert: 20))
            .environmentObject(screen)
            .environmentObject(Settings())
    }
}
