//
//  ArticleViewModel_MVVM.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleListViewModel_MVVM {
    let articlesVM: [ArticleViewModel_MVVM]
}

extension ArticleListViewModel_MVVM {
    
    init(_ articles: [Article_MVVM]) {
        self.articlesVM = articles.compactMap(ArticleViewModel_MVVM.init)
    }
    
}

extension ArticleListViewModel_MVVM {
    
    func articleAt(_ index: Int) -> ArticleViewModel_MVVM {
        return self.articlesVM[index]
    }
}

struct ArticleViewModel_MVVM {
    
    let article: Article_MVVM
    
    init(_ article: Article_MVVM) {
        self.article = article
    }
    
}

extension ArticleViewModel_MVVM {
    
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
    
}
