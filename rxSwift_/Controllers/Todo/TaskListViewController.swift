//
//  TaskListViewController.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/14.
//
import UIKit
import RxSwift
import RxCocoa
class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
//    private var tasks = Variable<[Task]>([])
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationItem.title = "ToDo"
        navigationItem.rightBarButtonItem  = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .plain, target: self, action: #selector(showToAddVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(goToBack))
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
       
        print(tasks.value.count)
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map{ tasks in
                return tasks.filter{ $0.priority == priority!}
            }.subscribe(onNext:{ [weak self] tasks in
                self?.filteredTasks = tasks
//                print(tasks)
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        self.filterTasks(by: priority)
    }
    
    
    
    
    @objc func goToBack(){
        self.dismiss(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        
        return cell
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let navC = segue.destination as? UINavigationController,
//              let addTVC = navC.viewControllers.first as? ToDoAddViewController else {fatalError("not found")}
//        addTVC.taskSubjectObservable
//            .subscribe(onNext:{ task in
//                print(task)
//            }).disposed(by: disposeBag)
//    }
    
}
