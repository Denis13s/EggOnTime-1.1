//
//  Screen.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 04/09/2023.
//

import Foundation

final class Screen: ObservableObject {
    @Published private(set) var width: CGFloat = 0
    @Published private(set) var height: CGFloat = 0
    
    @Published private(set) var paddingHSmall: CGFloat = 0
    @Published private(set) var paddingHBig: CGFloat = 0
    @Published private(set) var paddingVSmall: CGFloat = 0
    @Published private(set) var paddingVBig: CGFloat = 0
}

extension Screen {
    func updateSizes(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        paddingHSmall = self.width * 0.047
        paddingHBig = self.width * 0.081
        paddingVSmall = self.height * 0.024
        paddingVBig = self.height * 0.042
    
    }
}
