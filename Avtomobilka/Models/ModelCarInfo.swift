//
//  ModelCarInfo.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 05.08.2023.
//

import Foundation


struct ModelCarInfo: Decodable {
    let car: Info
    let user: User
}

struct Info: Decodable {
    let id, forSale: Int
    let brandName, modelName: String
    let year: Int
    let price: JSONNull?
    let brandID, modelID, engineID, transmissionID: Int
    let placeID, name, cityName, countryName: String
    let transmissionName, placeName: String
    let images: [ImageCar]
    let inSelectionCount, followersCount: Int
    let follow: Bool
    let engine, engineName, engineVolume: String
    let isModerated: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case forSale = "for_sale"
        case brandName = "brand_name"
        case modelName = "model_name"
        case year, price
        case brandID = "brand_id"
        case modelID = "model_id"
        case engineID = "engine_id"
        case transmissionID = "transmission_id"
        case placeID = "place_id"
        case name
        case cityName = "city_name"
        case countryName = "country_name"
        case transmissionName = "transmission_name"
        case placeName = "place_name"
        case images
        case inSelectionCount = "in_selection_count"
        case followersCount = "followers_count"
        case follow, engine
        case engineName = "engine_name"
        case engineVolume = "engine_volume"
        case isModerated = "is_moderated"
    }
}

struct User: Codable {
    let id: Int
    let username, email: String
    let about: String?
    let avatar: Avatar
    let autoCount: Int
    let mainAutoName: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, about, avatar
        case autoCount = "auto_count"
        case mainAutoName = "main_auto_name"
    }
}

struct Avatar: Codable {
    let path: String
    let url: String
}

