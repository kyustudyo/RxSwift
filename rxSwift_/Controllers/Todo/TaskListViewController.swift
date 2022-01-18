//
//  TaskListViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/14.
//
import UIKit
import RxSwift
import RxCocoa
let tableViewCell = "cell"
class TaskListViewController: UIViewController {

//MARK: - Properties
    
    private let prioritySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All","High","Medium","Low"])
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private let tableView = UITableView()
    private var filteredTasks = [Task]()
    let disposeBag = DisposeBag()
    
//MARK: - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "ToDo"
        navigationItem.rightBarButtonItem  = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .plain, target: self, action: #selector(showToAddVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(goToBack))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCell)
        tableView.tableFooterView = UIView()//2개가 있다면 2개까지만 seperate line 보이도록.
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(prioritySegmentedControl)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        prioritySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            prioritySegmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            prioritySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
       
        prioritySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
// MARK: - Helpers
    
    @objc func showToAddVC(){
        let vc = ToDoAddViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.taskSubjectObservable
            .subscribe(onNext:{ [unowned self] task in
                
//                self.tasks.value.append(task)
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
        nav.modalPresentationStyle = .overCurrentContext//fullscreen하면 마지막에 깜빡거림.
        present(nav, animated: true)
    }
    
    private func updateTableView(){
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {

        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map{ tasks -> Array<Task> in//@@
                print("1: ",tasks)
                return tasks.filter{ $0.priority == priority!}
            }.subscribe(onNext:{ [weak self] filtered in
                self?.filteredTasks = filtered
                print("filtered:",filtered)
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    @objc func goToBack(){
        self.dismiss(animated: true)
    }
    
    

}

//MARK: - TableView Delegate
    
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredTasks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath)
            cell.textLabel?.text = self.filteredTasks[indexPath.row].title
            return cell
            
        }
}
//MARK: - segmentedControlValueChanged
extension TaskListViewController {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl){
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        self.filterTasks(by: priority)
    }
}
