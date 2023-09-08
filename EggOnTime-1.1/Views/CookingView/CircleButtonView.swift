//
//  CircleButtonView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct CircleButtonView: View {
    
    @EnvironmentObject var screen: Screen
    
    @State var color: Color
    @State var imageColor: Color
    @State var image: String
    
    var body: some View {
        
        ZStack {
            Circle()
                .frame(height: screen.paddingVBig * 1.7)
                .foregroundColor(color)
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: screen.paddingVBig)
                .foregroundColor(imageColor)
        }
        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return CircleButtonView(color: MyColor.two, imageColor: MyColor.four, image: "arrow.counterclockwise")
            .environmentObject(screen)
    }
}
