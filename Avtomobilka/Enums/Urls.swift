//
//  Urls.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 02.08.2023.
//

import Foundation


enum URLs {
    case cars(_ page: Int)
    case carInfo(_ idCar: Int)
    case posts(_ idCar: Int, _ page: Int)
    
    var url: String {
        switch self {
            case .cars(let page):
                return "http://am111.05.testing.place/api/v1/cars/list?page=\(page)"
            case .carInfo(let idCar):
                return "http://am111.05.testing.place/api/v1/car/\(idCar)"
            case .posts(let idCar, let page):
                return "http://am111.05.testing.place/api/v1/car/\(idCar)/posts?page=\(page)"
        }
    }
}
