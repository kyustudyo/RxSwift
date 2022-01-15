//
//  NewsTableViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation

import UIKit
import RxSwift
class NewsTableViewController : UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "news!"
        navigationController?.navigationBar.prefersLargeTitles = true
        populateNews()
        configureUI()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCell else {return UITableViewCell()}
        cell.detailLabel.text = "a"
        cell.mainLabel.text = "a"
        print("complete")
        return cell
    }
    
    private func configureUI() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func populateNews() {
        
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1f32f1a3f3a042e498cec8738ff44706")!
        
        Observable.just(url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [Article]? in
                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
            }.subscribe(onNext: { [weak self] articles in
                
                if let articles = articles {
                    self?.articles = articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}
