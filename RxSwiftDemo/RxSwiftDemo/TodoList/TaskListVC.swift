//
//  TaskListVC.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 31/05/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListVC:UIViewController {
    
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var tasksArray = [Task]()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTaskVC = navC.viewControllers.first as? AddTaskVC else {
                  fatalError("Controller not found")
              }
        
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [weak self] task in
                
                let priority = Priority(rawValue: (self?.segmented.selectedSegmentIndex ?? 0))
                
               
                var existingTasks = self?.tasks.value ?? []
                existingTasks.append(task)
                
                self?.tasks.accept(existingTasks)
                
                self?.filterTasks(by: priority)
            })
            .disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority:Priority?) {
        if priority == nil {
            self.tasksArray = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.tasksArray = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex)
        filterTasks(by: priority)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension TaskListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell
        else { return UITableViewCell() }
        
        cell.backgroundColor = .red
        cell.taskName.text = self.tasksArray[indexPath.row].title
        
        return cell
    }
    
    
}

class TaskCell:UITableViewCell {
    
    @IBOutlet weak var taskName:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
}
