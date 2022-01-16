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
extension ArticlesList {
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1f32f1a3f3a042e498cec8738ff44706")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String
    let description: String? // 가끔 데이터 없는게 있다.
}
