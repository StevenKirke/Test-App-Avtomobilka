//
//  MainViewModel.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    private var requestData: RequestData = RequestData()
    private var jsonManager: DecodeJson = DecodeJson()
    
    @Published var listCars: [CarElement] = [CarElement]()
    @Published var page: Int = 1 {
        didSet {
            
        } willSet {
            if newValue == self.totalPage {
                isBlockLoad = true
            }
        }
    }
    @Published var totalPage: Int = 0
    @Published var currentId: Int = 0
    @Published var isLoad: Bool = false
    @Published var isBlockLoad: Bool = false
    
    init() {
        getData()
    }
    
    private func getMock() {
        let currentData = Data(mockCars.utf8)
        self.jsonManager.decodeJSON(data: currentData, model: listCars) { [weak self] json, error in
            if error != "" {
                print("Error - ", error)
            }
            guard let self = self else {
                return
            }
            guard let currentJSON = json else {
                return
            }
            self.listCars = currentJSON
        }
    }
    
    private func getCars() {
        self.isLoad = true
        self.requestData.getDataWithHeader(url: URLs.cars(self.page).url) { [weak self] data, error, page in
            guard let self = self else {
                return
            }
            if error != "" {
                print("Error - ", error)
            }
            if page != "" {
                if let cast = Int(page) {
                    self.totalPage = cast
                }
            } else {
                self.totalPage = 0
            }
            guard let currentData = data else {
                return
            }
            self.jsonManager.decodeJSON(data: currentData, model: self.listCars) { [weak self] json, error in
                if error != "" {
                    print("Error - ", error)
                }
                guard let self = self else {
                    return
                }
                guard let currentJSON = json else {
                    return
                }
                let oldData = self.listCars
                self.listCars = oldData + currentJSON
                self.page += 1
                self.isLoad = false
            }
        }
    }
    
    
    func getData() {
        if !isBlockLoad {
            getCars()
        }
    }

}
