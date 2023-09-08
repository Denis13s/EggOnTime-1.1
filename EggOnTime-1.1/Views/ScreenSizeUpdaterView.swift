//
//  ScreenSizeUpdaterView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 08/09/2023.
//

import SwiftUI

struct ScreenSizeUpdaterView: View {
    @EnvironmentObject var screen: Screen
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear.onAppear {
                screen.updateSizes(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
