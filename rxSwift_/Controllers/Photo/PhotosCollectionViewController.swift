//
//  PhotosCollectionViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/14.
//

import Foundation
import UIKit
import Photos
import RxSwift
private let reuseIdentifier_photo = "cell"

class PhotosCollectionViewController: UICollectionViewController {
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    private var images = [PHAsset]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        populatePhotos()
    }
   
    private func configureUI() {
        navigationItem.title = "Photo"
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier_photo)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else { return }
            //하나는 화질 안좋은거 나오므로 그거 재낀다.
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier_photo, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            
            DispatchQueue.main.async {
               cell.photoImageView.image = image
            }
            
        }
        
        return cell
        
    }
    
    private func populatePhotos() {
        //plist 수정 필요.
        //vc가 꺼지면 메모리 leak피하기 위해 weak self.
        
        //background thread에서 작동.
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                
                // access the photos from photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
//                print(self?.images)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
                
            }
            
        }
        
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - (5 * 5))/4
        let height: CGFloat = width + 0
        return CGSize(width: width, height: height)

    }
    
}
