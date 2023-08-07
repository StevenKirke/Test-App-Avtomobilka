//
//  CarInfoModel.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 04.08.2023.
//

import Foundation


class CarInfoModel: ObservableObject {
    private var requestData: RequestData = RequestData()
    private var jsonManager: DecodeJson = DecodeJson()
    
    @Published var carInfo: ModelCarInfo?
    @Published var posts: [PostElement] = []
    @Published var currentCar: Int = 0
    
    @Published var page: Int = 1 {
        didSet {

        } willSet {
            if newValue == self.totalPage {
                print("newValue - \(newValue)")
                isBlockLoad = true
            }
        }
    }
    @Published var totalPage: Int = 0 {
        didSet {
            if totalPage == 0 {
                print("oldValue - \(oldValue)")
                totalPage = oldValue
            }
        }
    }
    
    var isBlockLoad: Bool = false
    
    func getMock(currentCar: Int) {
        let currentData = Data(mockCarInfo.utf8)
        self.jsonManager.decodeJSON(data: currentData, model: carInfo) { [weak self] json, error in
            guard let self = self else {
                return
            }
            if error != "" {
                print("Error - ", error)
            }
            guard let currentJSON = json else {
                return
            }
            self.carInfo = currentJSON
            if carInfo != nil {
                self.getMockPost(currentCar: 49)
            }
        }
    }
    
    func getInfo(currentCar: Int) {
        let group = DispatchGroup()
        self.requestData.getData(url: URLs.carInfo(currentCar).url) { data, error in
            if error != "" {
                print("Error - ", error)
            }
            guard let currentData = data else {
                return
            }
            self.jsonManager.decodeJSON(data: currentData, model: self.carInfo) { [weak self] json, error in
                group.enter()
                if error != "" {
                    print("Error - ", error)
                }
                guard let self = self else {
                    return
                }
                guard let currentJSON = json else {
                    return
                }
                self.carInfo = currentJSON
                group.leave()
            }
            group.notify(queue: .main) {
                if self.carInfo != nil {
                    if self.isBlockLoad {
                        self.getPosts(currentCar: currentCar)
                    }
                }
            }
        }
    }
    
    func getMockPost(currentCar: Int) {
        let currentData = Data(mockPosts.utf8)
        self.jsonManager.decodeJSON(data: currentData, model: self.posts) { [weak self] json, error in
            guard let self = self else {
                return
            }
            if error != "" {
                print("Error - ", error)
            }
            guard let currentJSON = json else {
                return
            }
            //self.posts = currentJS
        }
    }
    
    func getPosts(currentCar: Int) {
        var currentPost: PostModel?
        let group = DispatchGroup()
        self.requestData.getDataWithHeader(url: URLs.posts(currentCar).url) { [weak self] data, error, totalPage in
            guard let self = self else {
                return
            }
            if error != "" {
                print("Error - ", error)
            }
            if totalPage != "" {
                if let cast = Int(totalPage) {
                    self.totalPage = cast
                }
            } else {
                self.totalPage = 0
            }
            guard let currentData = data else {
                return
            }
            self.jsonManager.decodeJSON(data: currentData, model: currentPost) { json, error in
                group.enter()
                if error != "" {
                    print("Error - ", error)
                }
                guard let currentJSON = json else {
                    return
                }
                currentPost = currentJSON
            }
            group.notify(queue: .main) {
                guard let post = currentPost?.posts else {
                    print("Error")
                    return
                }
                let oldData = self.posts
                    self.posts = oldData + post
                    self.page += 1
            }
        }
    }
    
}





