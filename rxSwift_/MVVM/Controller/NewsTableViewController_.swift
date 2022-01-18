//
//  NewsTableViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation
import UIKit
import RxSwift

let reuseIdentifier_MVVM = "cell"
class NewsTableViewController_: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel_!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        populateNews()
        
    }
    private func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(goToBack))
        navigationItem.title = "news MMVM"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(NewsCell_.self, forCellReuseIdentifier: reuseIdentifier_MVVM)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    @objc func goToBack(){
        self.dismiss(animated: true)
    }
//    private func populateNews() {
//
//        let resource = ArticlesList_MVVM.all
//
//
//        URLRequest.load(resource: resource)
//            .subscribe(onNext: {
//                print($0)
//            }).disposed(by: disposeBag)
//
//    }
    private func populateNews() {
        
        let resource = ArticlesList_.all
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                guard let articleResponse = articleResponse else {return}
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel_(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }).disposed(by: disposeBag)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListVM == nil ? 0 : articleListVM.articlesVM.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier_MVVM, for: indexPath) as? NewsCell_ else {return UITableViewCell()}
        
        //binding을 driver 또는 binding_function 으로 할 수 있다.
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.mainLabel.rx.text)
            .disposed(by: disposeBag)
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.detailLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
         
    }
    
    
}
