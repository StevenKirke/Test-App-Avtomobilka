//
//  NavigatorBarForCar.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 04.08.2023.
//

import SwiftUI

struct NavigatorBarForCar: View {
   
    var tittle: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: action) {
                Image.iconBack
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 65, height: 65)
            .padding(.leading, 2)
            Text(tittle)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.c_212529)
    }
}


#if DEBUG
struct _Previews: PreviewProvider{
    static var previews: some View {
        NavigatorBarForCar(tittle: "Name car", action: {})
    }
}
#endif
