//
//  Fonts.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import SwiftUI


extension Text {
    func fontBolt(size: CGFloat) -> some View {
        self
            .font(Font.custom("Arial-BoldMT", size: size))
    }
    
    func fontMedium(size: CGFloat) -> some View {
        self
            .font(Font.custom("ArialHebrew-Light", size: size))
    }
    

}
