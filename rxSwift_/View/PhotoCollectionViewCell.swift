//
//  PhotoCollectionViewCell.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/14.
//

import Foundation

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
