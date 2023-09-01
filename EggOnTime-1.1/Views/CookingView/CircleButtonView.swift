//
//  CircleButtonView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct CircleButtonView: View {
    
    @State var color: Color
    @State var imageColor: Color
    @State var image: String
    
    var body: some View {
        
        ZStack {
            Circle()
                .frame(height: 60)
                .foregroundColor(color)
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .foregroundColor(imageColor)
        }
        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(color: MyColor.two, imageColor: MyColor.four, image: "arrow.counterclockwise")
    }
}
