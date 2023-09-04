//
//  SelectingParameterView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct SelectingParameterView: View {
    
    @EnvironmentObject var model: CookingViewModel
    
    @State var title: String
    @State var parameter: Any
    let barHeight: CGFloat
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: barHeight / 8) {
            Text("\(title):")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(MyColor.four)
            
            // MARK: - EggSize
            if parameter is EggSize {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(EggSize.allCases, id: \.self) { parameter in
                            ZStack {
                                RoundedRectangle(cornerRadius: barHeight / 2)
                                    .foregroundColor(model.eggSize == parameter ?  MyColor.four : MyColor.two)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text(parameter.rawValue)
                                    .font(.callout)
                                    .foregroundColor(model.eggSize == parameter ?  MyColor.three : MyColor.four)
                                    .fontWeight(.light)
                            }
                            .onTapGesture {
                                withAnimation {
                                    model.eggSize = parameter
                                }
                            }
                        }
                    }
                }
                .frame(height: barHeight)
            }
            // MARK: - EggTemp
            else if parameter is EggTemp {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(EggTemp.allCases, id: \.self) { parameter in
                            ZStack {
                                RoundedRectangle(cornerRadius: barHeight / 2)
                                    .foregroundColor(model.eggTemp == parameter ?  MyColor.four : MyColor.two)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text(parameter.rawValue)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .foregroundColor(model.eggTemp == parameter ?  MyColor.three : MyColor.four)
                            }
                            .onTapGesture {
                                withAnimation {
                                    model.eggTemp = parameter
                                }
                            }
                        }
                    }
                }
                .frame(height: barHeight)
            }
            // MARK: - EggCondition
            else if parameter is EggCondition {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(EggCondition.allCases, id: \.self) { parameter in
                            ZStack {
                                RoundedRectangle(cornerRadius: barHeight / 2)
                                    .foregroundColor(model.eggCondition == parameter ?  MyColor.four : MyColor.two)
                                    .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 5, y: 5)
                                Text(parameter.rawValue)
                                    .font(.callout)
                                    .foregroundColor(model.eggCondition == parameter ?  MyColor.three : MyColor.four)
                                    .fontWeight(.light)
                            }
                            .onTapGesture {
                                withAnimation {
                                    model.eggCondition = parameter
                                }
                            }
                        }
                    }
                }
                .frame(height: barHeight)
            }
        }
       
        // var body
    }
}

struct SelectingParameterView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(MyColor.one)
            SelectingParameterView(title: "Size", parameter: EggTemp.refrigerated, barHeight: 40)
                .environmentObject(CookingViewModel())
        }
    }
}
