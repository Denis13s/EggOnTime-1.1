//
//  DividerView.swift
//  EggOnTime-1.1
//
//  Created by Denis Yarets on 01/09/2023.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1.5)
            .foregroundColor(MyColor.four)
            .mask {
                LinearGradient(colors: [.clear, .white, .clear], startPoint: .leading, endPoint: .trailing)
            }
        
        // var body
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(MyColor.one)
            DividerView()
        }
    }
}
