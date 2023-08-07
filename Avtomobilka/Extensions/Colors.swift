//
//  Colors.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 03.08.2023.
//

import SwiftUI

extension Color {
    enum Name: String {
        case c_212529
        case c_c2c3cb
        case c_f4f4f5
        case c_f8d055
    }
}

extension Color.Name {
    var path: String {
        "Colors/\(rawValue)"
    }
}

extension Color {
    init(_ name: Color.Name) {
        self.init(name.path)
    }
    
    static let c_212529 = Color(Name.c_212529)
    static let c_c2c3cb = Color(Name.c_c2c3cb)
    static let c_f4f4f5 = Color(Name.c_f4f4f5)
    static let c_f8d055 = Color(Name.c_f8d055)
}
