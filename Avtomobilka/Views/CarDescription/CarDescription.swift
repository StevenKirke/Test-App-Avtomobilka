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
    
    @State var currentIndex: Int = 0
    @State private var offset = CGFloat.zero
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    NavigatorBarForCar(tittle: name) {
                        self.returnMainView.wrappedValue.dismiss()
                    }
                    .onAppear() {
                        print("\(name) \(carID) \(image)")
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                       // VStack(spacing: 10) {
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
                                        .onTapGesture {
                                            print("\(carInfoVM.posts)")
                                        }
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
                                        LazyVStack {
                                            if elem == carInfoVM.posts.count - 1 {
                                                PostCar(post: carInfoVM.posts[elem], isShowPost: false)
                                                    .onAppear() {
                                                        self.carInfoVM.getInfo(currentCar: carID)
                                                    }
                                            } else {
                                                PostCar(post: carInfoVM.posts[elem], isShowPost: false)
                                            }
                                        }
                                    }
                                }

                            //}
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
                self.carInfoVM.getInfo(currentCar: carID)
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
    @State var isShowPost: Bool = false
    
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
            CustomImage(image: post.img ?? "")
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
                    .fixedSize(horizontal: false, vertical: true)
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
                            
                            Text(textShowPost)
                                .font(.system(size: 14, weight: .regular))
                        }
                    }
                    .foregroundColor(.c_212529)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
           // .frame(maxWidth: .infinity, alignment: .leading)

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
    
    let mockInfo: CarInfoModel = CarInfoModel()
    
    static var previews: some View {
        CarDescription(name: "Volkswagen",
                       carID: 49,
                       image: "http://am111.05.testing.place/uploads/user/37/auto/49/fc40ee0a0dbf97b2e504b2f48438a8ba_w500.jpg")
    }
}
#endif


let testPost: PostElement = PostElement(id: 563,
                                        text: "Доброго всем дня. Так как лето потихоньку приближается, начал я исследовать просторы интернета по поводу двадцатых тапочек на лето. В приоритете у меня, скажу честно, родные 20ые suzuka, хотя понравилось ещё пару вариантов от ABT.\r\n\r\nИ вот какой вопрос. На просторах авито помимо продажи оригинальных комплектов сузуки, увидел я реплики.\r\n\r\nПонятно, что в большинстве случаев реплика — это фупозоркактакможноваще, но, во-первых, кризис в стране :-), а, во-вторых, посещают паранойные мысли типа «приеду я покупать типа оригинальные, а это будут неоригиналы» Поэтому вопрос к знатокам. Видел может кто-то вживую эти неоригиналы, как они? И как отличить оригиналы от неоригиналов?",
                                        likeCount: 7,
                                        createdAt: "2019-02-24 21:53:19",
                                        commentCount: 3,
                                        img: "http://am111.05.testing.place/uploads/user/37/auto/49/post/563/b35648c11e2b74154d1d09c1a649b40f.jpg",
                                        author: CurrentUser(id: 1, username: "", avatar: Avatar(path: "", url: ""), autoCount: 1, mainAutoName: ""))


let testCarInfo: ModelCarInfo = ModelCarInfo(car: Info(id: 49, forSale: 0, brandName: "Volkswagen", modelName: "Tiguan", year: 2018, price: nil, brandID: 49, modelID: 49, engineID: 82, transmissionID: 2, placeID: "ChIJZf-0KTq_SkERpxQXi49I6WU", name: "Volkswagen Tiguan TSI AT 2018 г.", cityName: "", countryName: "", transmissionName: "AT", placeName: "", images: [], inSelectionCount: 0, followersCount: 15, follow: false, engine: "2.0 TSI", engineName: "TSI", engineVolume: "2.0", isModerated: true), user: testUser)

let testUser = User(id: 37, username: "lexer7", email: "7lexer7@tester.avtomobilka.com", about: nil, avatar: testAvatar, autoCount: 1, mainAutoName: "Volkswagen Tiguan")

let testAvatar: Avatar = Avatar(path: "uploads/user/37/avatars/hkVsjX1d8CUWIfNRLk4Bo29NBMFsAio1sQiKSV5o.jpg", url: "http://am111.05.testing.place/uploads/user/37/avatars/hkVsjX1d8CUWIfNRLk4Bo29NBMFsAio1sQiKSV5o.jpg")
