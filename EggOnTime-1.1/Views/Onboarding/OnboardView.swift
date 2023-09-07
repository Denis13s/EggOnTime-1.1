//
//  OnboardView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 07/09/2023.
//

import SwiftUI

struct OnboardView: View {
    
    @EnvironmentObject var screen: Screen
    
    @Binding var isOnboardingViewPresented: Bool
    
    let image: String
    let title: String
    let description: String
    let tag: Int
    let count: Int
    
    var body: some View {
        
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: (screen.height * 2 / 3) / 10 )
                        .frame(height: screen.height / 1.8)
                        .foregroundColor(MyColor.four)
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                    
                    Image("welcome-" + image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: screen.fontLarge))
                    .fontWeight(.bold)
                    .foregroundColor(MyColor.four)
                    .padding(.top, screen.paddingVBig)
                
                Text(description)
                    .multilineTextAlignment(.center)
                    .font(.system(size: screen.fontCallout))
                    .fontWeight(.light)
                    .foregroundColor(MyColor.four)
                    .padding(.top, screen.paddingVBig)
                Spacer()
                
                HStack (spacing: 0) {
                    ForEach (0..<count, id: \.self) { index in
                        Circle()
                            .foregroundColor(MyColor.four)
                            .frame(width: screen.fontCaption / 1.6, height: screen.fontCaption / 1.6)
                            .padding(screen.paddingHSmall / 4)
                            .opacity(tag == index ? 1.0 : 0.5)
                    }
                    
                    Spacer()
                    
                    Button { isOnboardingViewPresented.toggle() } label: {
                        if tag != (count - 1) {
                            Text("Skip")
                                .font(.system(size: screen.fontCallout))
                                .foregroundColor(MyColor.four)
                                .fontWeight(.light)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: screen.paddingVSmall)
                                    .foregroundColor(MyColor.four)
                                    .frame(width: screen.width * 0.3, height: screen.paddingVSmall * 2)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text("Get Started")
                                    .font(.system(size: screen.fontCallout))
                                    .foregroundColor(MyColor.three)
                                    .fontWeight(.light)
                            }
                        }
                    }
                }
                .padding(.top, screen.paddingVBig)
            }
            .padding(.horizontal, screen.paddingHBig)
            .padding(.bottom, screen.paddingVSmall)
        
        // var body
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return OnboardView(
            isOnboardingViewPresented: Binding.constant(true),
            image: "welcome",
            title: "Welcome to EggOnTime!",
            description: "Perfectly boiled eggs made easy",
            tag: 4,
            count: 5
        )
            .environmentObject(screen)
        
    }
}
