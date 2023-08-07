//
//  CarDescription.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 03.08.2023.
//

import SwiftUI

struct CarDescription: View {
    
    @Environment(\.presentationMode) var returnMainView: Binding<PresentationMode>
    
    @ObservedObject var carInfoVM: CarInfoModel = CarInfoModel()
    
    var name: String = ""
    var carID: Int = 0
    var image: String = ""
    
    var precent: CGFloat {
        (70 * UIScreen.main.bounds.width) / 100
    }
    let index: Int
    @Binding var curentIndexCarList: Int
    @State var currentIndex: Int = 0
    @State var isLoad: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    NavigatorBarForCar(tittle: name) {
                        self.curentIndexCarList = index
                        self.returnMainView.wrappedValue.dismiss()
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            HStack(spacing: 12) {
                                CustomImage(image: carInfoVM.carInfo?.user.avatar.url ?? "")
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 20)
                                    }
                                Text(carInfoVM.carInfo?.user.username ?? "Name")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.c_212529)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                            ZStack(alignment: .bottom) {
                                ScrollViewReader { geo in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach( self.carInfoVM.carInfo?.car.images.indices ?? 0..<1, id: \.self) { index in
                                                let image = self.carInfoVM.carInfo?.car.images[index].url ?? ""
                                                ImagePost(currentIndex: $currentIndex, index: index, image: image)
                                                    .frame(width: proxy.frame(in: .global).width - 40, height: precent)
                                                    .modifier(OffsetsModefier(currentIndex: $currentIndex, index: index))
                                            }
                                        }
                                    }
                                    .coordinateSpace(name: "SCROLL")
                                    .mask{
                                        RoundedRectangle(cornerRadius: 10)
                                    }
                                    .padding(.horizontal, 10)
                                    .onChange(of: currentIndex, perform: { _ in
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut) {
                                                geo.scrollTo(currentIndex, anchor: .topTrailing)
                                            }
                                        }
                                    })
                                }
                                HStack() {
                                    ForEach(self.carInfoVM.carInfo?.car.images.indices ?? 0..<1, id: \.self) { index in
                                        LittleCircle(currentIndex: $currentIndex, index: index)
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                            VStack(spacing: 10) {
                                let assambly = (carInfoVM.carInfo?.car.brandName ??  "") + " " + (carInfoVM.carInfo?.car.modelName ?? "")
                                Text(assambly)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.c_212529)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing: 10) {
                                    if let engineVolume = carInfoVM.carInfo?.car.engineVolume {
                                        TextBlock(text: engineVolume)
                                    }
                                    if let transmission = carInfoVM.carInfo?.car.transmissionName {
                                        TextBlock(text: transmission)
                                    }
                                    let year = String(carInfoVM.carInfo?.car.year ?? 0) + " г."
                                    TextBlock(text: year)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        }
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        VStack(spacing: 10) {
                            Text("Комментарии")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.c_212529)
                                .padding(.leading, 10)
                                .onAppear() {
                                    print(carInfoVM.posts.count)
                                }
                            if !carInfoVM.posts.isEmpty {
                                ForEach(0..<carInfoVM.posts.count, id: \.self) {   elem in
                                    LazyVStack(spacing: 0) {
                                        let isProgress = elem == (carInfoVM.posts.count - 1) ? true : false
                                        PostCar(post: carInfoVM.posts[elem], isLast: isProgress, isLoad: $isLoad)
                                            .onChange(of: isLoad, perform: { value in
                                                if isLoad && isProgress {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                            self.carInfoVM.getPostForCar()
                                                        }
                                                }
                                            })
                                        if isProgress {
                                            if !self.carInfoVM.isBlockLoad {
                                                ProgressView()
                                                    .tint(.c_212529)
                                                    .padding(.top, 20)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .mask{
                        RoundedRectangle(cornerRadius: 10)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.c_f4f4f5, .c_c2c3cb]),
                               startPoint: .trailing, endPoint: .leading)
            )
            .onAppear() {
                self.carInfoVM.currentCar = carID
                self.carInfoVM.getInfoCar()
                print("currentCar - \(carInfoVM.currentCar)")
            }
            .onDisappear() {
                self.carInfoVM.totalPage = 0
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ImagePost: View {
    
    @Binding var currentIndex: Int
    let index: Int
    let image: String
    var body: some View {
        CustomImage(image: image)
            .scaledToFill()
            .cornerRadius(10)
            .tag("\(image)")
    }
}


struct LittleCircle: View {
    
    @Binding var currentIndex: Int
    let index: Int
    
    var body: some View {
        Circle()
            .fill(currentIndex == index ? Color.white : Color.white.opacity(0.1))
            .frame(height: 10)
    }
}


struct PostCar: View {
    
    var post: PostElement
    var isLast: Bool
    @State var isShowPost: Bool = false
    @Binding var isLoad: Bool
    
    var textShowPost: String {
        if isShowPost {
            "Свернуть комментарии"
        } else {
            "Посмотреть ответы (" + String(post.commentCount) + ")"
        }
    }
    
    var precent: CGFloat {
        (80 * UIScreen.main.bounds.width) / 100
    }
    
    var body: some View {
        
        VStack(alignment: .trailing, spacing: 15) {
            CustomImage(image: post.img ?? "none")
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 40, height: precent)
                .cornerRadius(10)
            HStack(spacing: 0) {
                Text(post.createdAt.convertDate() + " г.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.c_212529)
                    .lineLimit(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                PostButton(image: "heart", text: String(post.likeCount), action: {})
                    .foregroundColor(Color.red)
            }
            HStack(alignment: .top, spacing: 10) {
                let autor  = post.author.username
                CustomImage(image: post.author.avatar.url)
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .mask {
                        RoundedRectangle(cornerRadius: 20)
                    }
                VStack(spacing: 15) {
                    Group {
                        Text(autor + ":  ")
                            .font(.system(size: 14, weight: .black))
                        + Text(post.text)
                            .font(.system(size: 14, weight: .regular))
                    }
                    .foregroundColor(.c_212529)
                    .lineLimit(isShowPost ? nil : 3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.c_212529)
                            .frame(width: 20, height: 1)
                        Button(action: {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    self.isShowPost.toggle()
                                }
                            }
                        }) {
                            if isLast {
                                Text(textShowPost)
                                    .font(.system(size: 14, weight: .regular))
                                    .onAppear() {
                                        self.isLoad = true
                                    }
                                
                            } else {
                                Text(textShowPost)
                                    .font(.system(size: 14, weight: .regular))
                            }
                        }
                    }
                    .foregroundColor(.c_212529)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(13)
    }
}

struct PostButton: View {
    
    let image: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: action) {
                Image(systemName: image)
                    .foregroundColor(.c_212529)
            }
            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.c_212529)
        }
    }
}


#if DEBUG
struct CarDescription_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(globalModel: GlobalModel())
    }
}
#endif
