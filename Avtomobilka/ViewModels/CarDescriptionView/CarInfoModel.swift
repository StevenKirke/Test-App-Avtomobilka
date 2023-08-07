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
            if oldValue == self.totalPage {
                print("Block load post")
                isBlockLoad = true
            }
        } willSet {
            if newValue == self.totalPage {

            }
        }
    }
    @Published var totalPage: Int = 0
    
    var isBlockLoad: Bool = false
    
   private func getMock(currentCar: Int) {
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
                self.getMockPost()
            }
        }
    }
    
    private func getInfo() {
        let group = DispatchGroup()
        self.requestData.getData(url: URLs.carInfo(self.currentCar).url) { data, error in
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
                    if !self.isBlockLoad {
                        self.getPosts()
                    }
                }
            }
        }
    }
    
    private func getMockPost() {
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
            self.posts = currentJSON
        }
    }
    
    private func getPosts() {
        var currentPost: PostModel?
        let group = DispatchGroup()
        self.requestData.getDataWithHeader(url: URLs.posts(self.currentCar, page).url) { [weak self] data, error, totalPage in
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
                guard let tempPost = currentPost?.posts else {
                    print("Error")
                    return
                }
                let oldData = self.posts
                    self.posts = oldData + tempPost
                    self.page += 1
            }
        }
    }
    
    func getInfoCar() {
        getInfo()
    }
    
    func getPostForCar() {
        if !isBlockLoad {
            getPosts()
        }
    }
    
}





