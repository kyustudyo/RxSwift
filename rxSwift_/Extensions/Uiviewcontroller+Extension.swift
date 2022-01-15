//
//  Uiviewcontroller+Extension.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation
import UIKit

extension UIViewController {
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]//글자색
//            appearance.backgroundColor = .systemPurple
        
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance//스크롤할때 '바' 수축.
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
            navigationItem.title = title
            navigationController?.navigationBar.tintColor = .brown//사람 버튼색
            navigationController?.navigationBar.isTranslucent = true
    
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        }
}
