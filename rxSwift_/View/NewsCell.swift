//
//  NewsCell.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation

import UIKit

class NewsCell : UITableViewCell {
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "하나둘셋 야"
        label.numberOfLines = 0
        
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "야야 야야야야 야야야야야야 으쌰샤으쌰"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [mainLabel, detailLabel])
        stack.axis = .vertical
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        
        mainLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
