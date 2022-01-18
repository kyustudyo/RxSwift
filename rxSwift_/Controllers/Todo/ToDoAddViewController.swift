//
//  showToAddVC.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import UIKit
import RxSwift

class ToDoAddViewController : UIViewController{
    
    //MARK: - Properties
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    private let segmentControl : UISegmentedControl = {
        let control = UISegmentedControl(items: ["High","Medium","Low"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let textField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(string: "todo", attributes: [.foregroundColor : UIColor.systemGray])
        textField.font = UIFont.systemFont(ofSize: 16)
        
        return textField
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    //MARK: - Helpers
    
    func configureUI(){
//        view.backgroundColor = .black
        navigationItem.title = "todo add"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "scribble"), style: .plain, target: self, action: #selector(save))
        view.addSubview(segmentControl)
        view.addSubview(textField)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.7),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func save(){
        guard let priority = Priority(rawValue: self.segmentControl.selectedSegmentIndex) // enum
        ,let title = self.textField.text else {return}
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
}
