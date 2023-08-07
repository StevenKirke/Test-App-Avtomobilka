//
//  CustomNavigationView.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 03.08.2023.
//

import SwiftUI


struct CustomNavigationView: View {
    
    @Binding var isLoad: Bool
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: action) {
                Image.iconCar
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 65, height: 65)
            .padding(.leading, 15)
            Text("Avtomobilka")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.c_212529)
    }
}




#if DEBUG
struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView(isLoad: .constant(false), action: {})
    }
}
#endif

