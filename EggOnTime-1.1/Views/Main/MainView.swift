//
//  ContentView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

/*
 MARK: Features
 - EggOnTime_App: setting timeStartedStored (Stopwatch property) to nil every time the app is relaunched
 
 TODO: -
 - If notification permission denied, tell the user about it and maybe he'd like to give permission
 - Add settings: Disable sound, disable notifications
 - Add vibrations
 - Maybe worth to put all ui inside scrollview and button start on top in a ZStack, if screen is smaller, this could save preview
 - !Timer stops while screen in blocked. Need rework
 - Slow down the timer in it's model for the final launch
 
 - Adaptable size for every screen (even for gradient size in BG)
 - Running progress in BG notification
 - Vibration
 - What about the images. Why there're so many option for their sizes?
 */

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var model: CookingViewModel
    
    @State var isCookingViewPresented = false
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(RadialGradient(colors: [MyColor.two, MyColor.one], center: .center, startRadius: 0, endRadius: 600))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                /*
                // MARK: - Top buttons
                HStack {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(systemName: "line.3.horizontal.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                .foregroundColor(MyColor.four.opacity(0.5))
                .padding()
                */
                Spacer()
                Group {
                    // MARK: - Preview
                    GeometryReader { geometry in
                        EggMainView(height: geometry.size.height)
                    }
                    
                    // MARK: - Parameters
                    VStack(spacing: 20) {
                        SelectingParameterView(title: "Size", parameter: EggSize.m, barHeight: 40)
                        SelectingParameterView(title: "Temperature", parameter: EggTemp.refrigerated, barHeight: 40)
                        SelectingParameterView(title: "Condition", parameter: EggCondition.medium, barHeight: 40)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Divider
                    DividerView()
                        .padding(.top, 35)
                    
                    // MARK: - Start Button
                    Button {
                        isCookingViewPresented.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 120, height: 60)
                                .foregroundColor(MyColor.four)
                            Text("Start")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(MyColor.three)
                        }
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                    }
                    .padding(.vertical, 35)
                }
                .padding(.horizontal, 35)
                // If there is no top buttons, should be padding 20 from top
//                .padding(.top, 20)
            }

        }
        .fullScreenCover(isPresented: $isCookingViewPresented) {
            CookingView(isCookingViewPresented: $isCookingViewPresented)
                .environmentObject(Stopwatch(timeTimer: model.timeCooking.all))
        }
        
        // var body
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(CookingViewModel())
    }
}
