//
//  SideMenuView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 05/09/2023.
//

import SwiftUI

struct SideMenuView: View {
    
    @EnvironmentObject var screen: Screen
    
    @Binding var isSideMenuViewPresented: Bool
    
    @State private var isNotificationEnabled = false
    @State private var isSoundEnabled = false
    @State private var isVibrationEnabled = false
    @State private var isDarkModeEnabled = false
    
    
    var body: some View {
        
        ZStack {
            if isSideMenuViewPresented {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isSideMenuViewPresented.toggle() }
                
                HStack {
                    ZStack{
                        Rectangle()
                            .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: screen.height * 0.9))
                            .frame(width: screen.width * 2 / 3)
                            .ignoresSafeArea()
                        
                        VStack(alignment: .leading, spacing: screen.paddingVSmall) {
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
                            
                            Toggle(isOn: $isNotificationEnabled) {
                                Text("Notifications")
                                    .font(.system(size: screen.fontCallout))
                                    .fontWeight(.bold)
                                    .foregroundColor(MyColor.four)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: MyColor.three))
                                
                            Toggle(isOn: $isSoundEnabled) {
                                Text("Sound")
                                    .font(.system(size: screen.fontCallout))
                                    .fontWeight(.bold)
                                    .foregroundColor(MyColor.four)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: MyColor.three))
                            
                            Toggle(isOn: $isVibrationEnabled) {
                                Text("Vibration")
                                    .font(.system(size: screen.fontCallout))
                                    .fontWeight(.bold)
                                    .foregroundColor(MyColor.four)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: MyColor.three))
                            
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Dark Mode")
                                    .font(.system(size: screen.fontCallout))
                                    .fontWeight(.bold)
                                    .foregroundColor(MyColor.four)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: MyColor.three))
                            
                            DividerView()
                                .padding(.top, screen.paddingVBig)
                            Spacer()
                            
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
                        }
                        .padding(.vertical, screen.paddingVBig)
                        .padding(.horizontal, screen.paddingHSmall)
                        .frame(width: screen.width * 2 / 3)
                    }
                    Spacer()
                    
                }
                .background(.clear)
                .transition(.move(edge: .leading))
                .background( Color.clear )
            }
        }
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
    }
}
