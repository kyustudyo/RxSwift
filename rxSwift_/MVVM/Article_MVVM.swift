//
//  Article_MVVM.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
struct ArticlesList_MVVM: Decodable {
    let articles: [Article_MVVM]
}
extension ArticlesList_MVVM {
    static var all: Resource<ArticlesList_MVVM> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1f32f1a3f3a042e498cec8738ff44706")!
        return Resource(url: url)
    }()
}

struct Article_MVVM: Decodable {
    let title: String
    let description: String? // 가끔 데이터 없는게 있다.
}
