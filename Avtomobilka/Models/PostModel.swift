//
//  PostModel.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 06.08.2023.
//

import Foundation


struct PostModel: Decodable {
    let posts: [PostElement]
    let user: CurrentUser
}

struct PostElement: Decodable {
    let id: Int
    let text: String
    let likeCount: Int
    let createdAt: String
    let commentCount: Int
    let img: String?
    let author: CurrentUser

    enum CodingKeys: String, CodingKey {
        case id, text
        case likeCount = "like_count"
        case createdAt = "created_at"
        case commentCount = "comment_count"
        case img, author
    }
}

struct CurrentUser: Decodable {
    let id: Int
    let username: String
    let avatar: Avatar
    let autoCount: Int
    let mainAutoName: String

    enum CodingKeys: String, CodingKey {
        case id, username, avatar
        case autoCount = "auto_count"
        case mainAutoName = "main_auto_name"
    }
}



