//
//  NewsTableViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation

import UIKit
import RxSwift
private let reuseIdentifier = "cell"

class NewsTableViewController : UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        populateNews()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NewsCell else {return UITableViewCell()}
        cell.mainLabel.text = self.articles[indexPath.row].title
        cell.detailLabel.text = self.articles[indexPath.row].description
        return cell
    }
    
    private func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(goToBack))
        navigationItem.title = "news!"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(NewsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    @objc func goToBack(){
        self.dismiss(animated: true)
    }
    
    private func populateNews() {
        

        URLRequest.load(resource: ArticlesList.all)
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.articles = result.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
//        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1f32f1a3f3a042e498cec8738ff44706")!
//        
//        let resource = Resource<ArticlesList>(url: url)
                
//        Observable.just(url)
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//                return URLSession.shared.rx.data(request: request)
//            }.map { data -> [Article]? in
////                print("data:",String(data: data, encoding: .utf8))
//                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
//            }.subscribe(onNext: { [weak self] articles in
//
//                if let articles = articles {
//                    self?.articles = articles
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    
    
    
    
}
