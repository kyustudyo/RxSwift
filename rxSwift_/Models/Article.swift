//
//  Article.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String
}
