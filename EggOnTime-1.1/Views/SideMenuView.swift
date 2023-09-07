//
//  SideMenuView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 05/09/2023.
//

import SwiftUI

struct SideMenuView: View {
    
    @EnvironmentObject var screen: Screen
    @EnvironmentObject var settings: Settings
    
    @Binding var isSideMenuViewPresented: Bool
    
    @State private var dragOffset: CGFloat = 0.0
    
    private var width: CGFloat { screen.width * 2 / 3 }
    
    var body: some View {
        
        ZStack {
            if isSideMenuViewPresented {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isSideMenuViewPresented.toggle() }
                
                HStack {
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                            .frame(width: width)
                            .ignoresSafeArea()
                        
                        VStack(alignment: .leading, spacing: screen.paddingVSmall) {
                            // MARK: - Logo
                            HStack(spacing: screen.paddingVSmall / 2) {
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: screen.fontLarge * 0.8)
                                    .foregroundColor(MyColor.two)
                                
                                Text("EggOnTime")
                                    .font(.system(size: screen.fontLarge * 0.8))
                                    .fontWeight(.bold)
                                    .foregroundColor(MyColor.four)
                            }
                            .padding(.bottom, screen.paddingVBig)
                            
                            // MARK: - Toggles
                            ToggleView(isEnabled: $settings.isNotificationEnabled, title: "Notifications", textColor: MyColor.four, toggleColor: MyColor.three)
                            
                            ToggleView(isEnabled: $settings.isSoundEnabled, title: "Sound", textColor: MyColor.four, toggleColor: MyColor.three)
                            
                            ToggleView(isEnabled: $settings.isVibrationEnabled, title: "Vibration", textColor: MyColor.four, toggleColor: MyColor.three)
                            
                            ToggleView(isEnabled: $settings.isDarkModeEnabled, title: "Dark Mode", textColor: MyColor.four, toggleColor: MyColor.three)
                            
                            DividerView()
                                .padding(.top, screen.paddingVBig)
                            Spacer()
                            
                            /*
                             // MARK: - Button
                             Button {  } label: {
                             ZStack {
                             RoundedRectangle(cornerRadius: screen.height * 0.04)
                             .frame(height: screen.paddingVSmall * 2)
                             .foregroundColor(MyColor.two)
                             Text("Help & Feedback")
                             .font(.system(size: screen.fontCallout))
                             .fontWeight(.medium)
                             .foregroundColor(MyColor.four)
                             }
                             .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                             }
                             .padding(.top, screen.paddingVBig)
                             */
                        }
                        .padding(.vertical, screen.paddingVBig)
                        .padding(.horizontal, screen.paddingHSmall)
                        .frame(width: width)
                    }
                }
                .transition(.move(edge: .trailing))
                .offset(x: dragOffset) // Apply the drag offset
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = max(value.translation.width, 0) /// Prevent dragging to the left
                }
                .onEnded { value in
                    if value.translation.width > screen.width / 2 { isSideMenuViewPresented.toggle() }
                    // Reset the offset
                    dragOffset = 0.0
                }
        )
        .animation(.easeInOut, value: isSideMenuViewPresented)
        
        // var body
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return SideMenuView(isSideMenuViewPresented: Binding.constant(true))
            .environmentObject(screen)
            .environmentObject(Settings())
    }
}
