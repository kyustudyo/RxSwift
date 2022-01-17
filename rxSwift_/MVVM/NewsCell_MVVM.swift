//
//  NewsCell_MVVM.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/17.
//

import Foundation

import UIKit

class NewsCell_MVVM : UITableViewCell {
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [mainLabel, detailLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor,constant: 4),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -4),
            stack.rightAnchor.constraint(equalTo: rightAnchor,constant: -12),
            stack.leftAnchor.constraint(equalTo: leftAnchor,constant: 12)
        ])
        mainLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
