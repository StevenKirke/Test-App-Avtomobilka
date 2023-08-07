//
//  MainView.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import SwiftUI


struct MainView: View {
    
    @StateObject var globalModel: GlobalModel
    @ObservedObject var mainVM: MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    CustomNavigationView(isLoad: self.$mainVM.isLoad) {
                        DispatchQueue.main.async {
                            withAnimation {
                                // proxy.scrollTo(10, anchor: .top)
                            }
                        }
                    }
                    List(0..<mainVM.listCars.count, id: \.self) { elem in
                        VStack(spacing: 0) {
                            if elem == self.mainVM.listCars.count - 1 {
                                CellView(car: self.mainVM.listCars[elem], isLast: true, id: elem, mainVM: self.mainVM)
                            } else {
                                CellView(car: self.mainVM.listCars[elem], isLast: false, id: elem, mainVM: self.mainVM)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                    
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.c_f4f4f5, .c_c2c3cb]),
                                   startPoint: .trailing, endPoint: .leading)
                )
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}



struct CellView: View {
    
    let car: CarElement
    var isLast: Bool
    let id: Int
    @ObservedObject var mainVM: MainViewModel
    
    var precent: CGFloat {
        (80 * UIScreen.main.bounds.width) / 100
    }
    
    var assamply: String {
        car.brandName + " " +  car.modelName + " " + car.engineName
    }
    
    var year: String {
        if !String(car.year).isEmpty  {
            return String(car.year) + " г."
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CustomImage(image: car.image)
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30, height: precent)
                .cornerRadius(10)
            HStack(spacing: 10) {
                Text(assamply)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.c_212529)
            }
            if self.isLast {
                HStack(spacing: 10) {
                    if !car.transmissionName.rawValue.isEmpty {
                        TextBlock(text: car.transmissionName.rawValue)
                    }
                    let year = String(car.year) + " г."
                    TextBlock(text: year)
                }
                .onAppear() {
                    self.mainVM.getData()
                }
            } else {
                HStack(spacing: 10) {
                    if !car.transmissionName.rawValue.isEmpty {
                        TextBlock(text: car.transmissionName.rawValue)
                    }
                    if !String(car.year).isEmpty  {
                        let year = String(car.year) + " г."
                        TextBlock(text: year)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(12)
        .background(
            NavigationLink(destination: CarDescription(name: car.brandName,
                                                       carID: car.id,
                                                       image: car.thumbnail)) {
                                                       }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
        )
    }
}

struct TextBlock: View {
    
    var text: String = ""
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .regular))
            .padding(.vertical, 4)
            .padding(.horizontal, 15)
            .foregroundColor(.c_212529)
            .overlay(
                Capsule()
                    .stroke(Color.c_212529.opacity(0.6))
            )
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider{
    static var previews: some View {
        MainView(globalModel: GlobalModel())
    }
}
#endif
