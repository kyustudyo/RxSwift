//
//  ViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/13.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .plain, target: self, action: #selector(showToDoVC))//navigation controller 붙히면 안된다.
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        super.viewDidLoad()
        
        //이렇게해야 large title 보인다.
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
//            self?.photoImageView.image = photo
            self?.updateUI(with: photo)
        }).disposed(by: disposeBag)
        
    }
    @IBAction func applyFilterButtonPressed(){
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
    @objc func showToDoVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController else {return}
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        //nav 였는데 또 nav 하면 새로운 nav로 나타난다.
        present(nav, animated: true, completion: nil)
    }

}

