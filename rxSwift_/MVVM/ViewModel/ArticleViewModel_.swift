//
//  ArticleViewModel_MVVM.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleListViewModel_ {
    let articlesVM: [ArticleViewModel_]
}

extension ArticleListViewModel_ {
    
    init(_ articles: [Article_]) {
        self.articlesVM = articles.compactMap(ArticleViewModel_.init)
    }
    
}
extension ArticleListViewModel_ {
    
    func articleAt(_ index: Int) -> ArticleViewModel_ {
        return self.articlesVM[index]
    }
}



struct ArticleViewModel_ {
    
    let article: Article_
    
    init(_ article: Article_) {
        self.article = article
    }
    
}

extension ArticleViewModel_ {
    
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
    
}
