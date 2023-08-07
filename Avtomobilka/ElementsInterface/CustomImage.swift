//
//  CustomImage.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 03.08.2023.
//

import SwiftUI

struct CustomImage: View {
    
    let image: String
    
    var body: some View {
        
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                        .tint(.c_212529)
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image(.NoImage)
                        .resizable()
                        .foregroundColor(.c_212529.opacity(0.2))
                        .background(Color.c_212529.opacity(0.1))
                @unknown default:
                    Image(.NoImage)
                        .resizable()
                        .foregroundColor(.c_212529.opacity(0.2))
            }
        }
    }
}

