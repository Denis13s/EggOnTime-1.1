//
//  EggMainView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct EggMainView: View {
    
    @EnvironmentObject var model: CookingViewModel
    @EnvironmentObject var screen: Screen
    
    @State var image = "egg-medium"
    @State private var imagePadding: CGFloat = 0.0
    
    let height: CGFloat
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: (height * 2 / 3) / 10 )
                .frame(height: height * 2 / 3)
                .foregroundColor(MyColor.four)
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
            
            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        ZStack {
                            Image("egg-empty")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding(.top, imagePadding)
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            ZStack {
                                Circle()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: screen.paddingVSmall * 2, height:  screen.paddingVSmall * 2)
                                    .foregroundColor(model.eggTemp == .refrigerated ? MyColor.four : MyColor.two)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                
                                Image(systemName: model.eggTemp == .refrigerated ? "snowflake" : "sun.max")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: screen.paddingVSmall)
                                    .foregroundColor(model.eggTemp == .refrigerated ? MyColor.three : MyColor.four)
                            }
                            .padding(screen.paddingVBig)
                            Spacer()
                        }
                    }
                }
                
                VStack(spacing: 0) {
                    Text(model.timeFormatted.min + ":" + model.timeFormatted.sec)
                        .font(.system(size: screen.fontLarge))
                        .fontWeight(.bold)
                    
                    Text("Estimated Time")
                        .font(.system(size: screen.fontCaption))
                        .fontWeight(.light)
                }
                .foregroundColor(MyColor.three)
                .padding(.bottom, screen.paddingVSmall)
            }
        }
        .onAppear {
            imagePadding = screen.paddingVSmall * 2 /// default size for the medium size
        }
        .onChange(of: model.eggCondition) { newValue in
            withAnimation {
                switch newValue {
                case .soft: image = "egg-soft"
                case .medium: image = "egg-medium"
                case .hard: image = "egg-hard"
                }
            }
        }
        .onChange(of: model.eggSize) { newValue in
            withAnimation {
                switch newValue {
                case .s: imagePadding = screen.paddingVSmall * 3
                case .m: imagePadding = screen.paddingVSmall * 2
                case .l: imagePadding = screen.paddingVSmall
                case .xl: imagePadding = 0.0
                }
            }
        }
        
        // var body
    }
}

struct EggMainView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(MyColor.one)
            
            EggMainView(height: 759)
                .environmentObject(CookingViewModel())
                .environmentObject(Screen())
        }
    }
}
