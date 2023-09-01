//
//  EggCookingView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct EggCookingView: View {
    
    @EnvironmentObject var model: CookingViewModel
    @EnvironmentObject var stopwatch: Stopwatch
    
    @State var opacityRaw = 1.0
    @State var opacityEmpty = 0.0
    @State var opacitySoft = 0.0
    @State var opacityMedium = 0.0
    @State var opacityHard = 0.0
    
    
    let timeDelay = 10
    
    var body: some View {
        ZStack {
            Image("egg-empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacityEmpty)
            
            Image("egg-raw")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacityRaw)
            
            Image("egg-soft")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacitySoft)
            
            Image("egg-medium")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacityMedium)
            
            Image("egg-hard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacityHard)
        }
        .onChange(of: stopwatch.timePassed) { newValue in
            if newValue <= model.timeCooking.soft {
                let ratio = newValue / model.timeCooking.soft
                opacityEmpty = ratio
                opacityRaw = 1.0 - ratio
                opacitySoft = ratio
                opacityMedium = 0.0
                opacityHard = 0.0
            }
            else if newValue <= model.timeCooking.medium {
                let ratio = (newValue - model.timeCooking.soft) / (model.timeCooking.medium - model.timeCooking.soft)
                opacityEmpty = 1.0
                opacityRaw = 0.0
                opacitySoft = 1.0 - ratio
                opacityMedium = ratio
                opacityHard = 0.0
            }
            else if newValue <= model.timeCooking.hard {
                let ratio = (newValue - model.timeCooking.medium) / (model.timeCooking.hard - model.timeCooking.medium)
                opacityEmpty = 1.0
                opacityRaw = 0.0
                opacitySoft = 0.0
                opacityMedium = 1.0 - ratio
                opacityHard = ratio
            }
            else {
                opacityEmpty = 1.0
                opacityRaw = 0.0
                opacitySoft = 0.0
                opacityMedium = 0.0
                opacityHard = 1.0
            }
        }
        
        // var body
    }
}

struct EggCookingView_Previews: PreviewProvider {
    static var previews: some View {
        EggCookingView()
            .environmentObject(CookingViewModel())
            .environmentObject(Stopwatch())
    }
}
