//
//  Images.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 03.08.2023.
//

import SwiftUI


extension Image {
    
    enum Icons: String {
        case logoCar
        case BackIcon
        case NoImage
    }
    
    init( _ name: Image.Icons) {
        self.init(name.path)
    }
    
    static let iconCar = Image(Icons.logoCar)
    static let iconBack = Image(Icons.BackIcon)
    static let noImage = Image(Icons.NoImage)
}

extension Image.Icons {
    var path: String {
        "Images/Icons/\(rawValue)"
    }
}

