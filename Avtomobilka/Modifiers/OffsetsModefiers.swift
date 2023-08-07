//
//  OffsetsModefiers.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 06.08.2023.
//

import SwiftUI

struct OffsetsModefier: ViewModifier {
    
    @Binding var currentIndex: Int
    let index: Int
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("SCROLL")))
                }
            )
            .onPreferenceChange(OffsetKey.self) { proxy in
                withAnimation(.easeInOut) {
                    let offset = proxy.minY
                    currentIndex = (offset < proxy.midX && currentIndex != index)  ? index : currentIndex
                }
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
