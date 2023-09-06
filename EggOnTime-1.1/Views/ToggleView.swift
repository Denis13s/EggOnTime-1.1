//
//  ToggleView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 06/09/2023.
//

import SwiftUI

struct ToggleView: View {
    
    @EnvironmentObject var screen: Screen
    
    @Binding var isEnabled: Bool
    
    @State var title: String
    @State var textColor: Color
    @State var toggleColor: Color
    
    var body: some View {
        
        Toggle(isOn: $isEnabled) {
            Text(title)
                .font(.system(size: screen.fontCallout))
                .fontWeight(.bold)
                .foregroundColor(MyColor.four)
        }
        .toggleStyle(SwitchToggleStyle(tint: toggleColor))
        
        // var body
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        let screen = Screen()
        screen.updateSizes(width: 430, height: 839)
        
        return ZStack {
            Rectangle()
            ToggleView(isEnabled: Binding.constant(true), title: "Notifications", textColor: MyColor.four, toggleColor: MyColor.three)
                .environmentObject(screen)
        }
    }
}
