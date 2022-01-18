//
//  ViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/13.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

//    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    private let photoImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let applyFilterButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(applyFilterButtonPressed), for: .touchUpInside)
        button.setTitle("Filter!", for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        //이렇게해야 large title 보인다.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let navC = segue.destination as? UINavigationController,
//            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
//                fatalError("Segue destination is not found")
//        }
//        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
//            self?.updateUI(with: photo)
//        }).disposed(by: disposeBag)
//
//    }
    
    private func configureUI(){
        view.backgroundColor = .white
        self.navigationItem.title = "Main"
        let toDo =  UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(showToDoVC))
        let news =  UIBarButtonItem(image: UIImage(systemName: "doc.text.fill"), style: .plain, target: self, action: #selector(showNewsVC))
        let weather = UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .plain, target: self, action: #selector(showWeatherVC))
        let news_MVVM = UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .plain, target: self, action: #selector(showNewsVC_MVVM))
        let photo = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showPhotoVC))
        navigationItem.leftBarButtonItems = [toDo, news, weather,news_MVVM]
        navigationItem.rightBarButtonItems = [photo]
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoImageView)
        view.addSubview(applyFilterButton)
        
        let buttonBottomAnchor =  applyFilterButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)


        let buttonTopAnchor = applyFilterButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 24)
        
        
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            
            applyFilterButton.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            applyFilterButton.widthAnchor.constraint(equalToConstant: 130),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonBottomAnchor,
            buttonTopAnchor
            
        ])
        buttonBottomAnchor.priority = .defaultHigh
        buttonTopAnchor.priority = .defaultLow
            }
    
     @objc func applyFilterButtonPressed(){
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        //기존 방식.
//        FiltersService().applyFilter(to: sourceImage) { filteredImage in
//
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//
//        }
        
        //rx 방식.
        FiltersService().applyFilter(to: sourceImage)
         .subscribe(onNext: { filteredImage in
             DispatchQueue.main.async {
                 self.photoImageView.image = filteredImage
             }
         }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        //view.backgroundColor = .gray
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    // MARK: - Storyboard
    @objc func showToDoVC(){
        let vc = TaskListViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle  = .overCurrentContext
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Programmaticaly
    @objc func showNewsVC(){
        let vc = NewsTableViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle  = .overCurrentContext
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showWeatherVC(){
        let vc = GoodWeatherViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle  = .overCurrentContext
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showNewsVC_MVVM(){
        let vc = NewsTableViewController_()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle  = .overCurrentContext
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }
    @objc func showPhotoVC(){
        let layout = UICollectionViewFlowLayout()
        let vc = PhotosCollectionViewController(collectionViewLayout: layout)
        vc.selectedPhoto.subscribe(onNext:{[weak self] photo in
            self?.updateUI(with: photo)
        }).disposed(by: disposeBag)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle  = .overCurrentContext
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }
    

}

