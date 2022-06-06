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
    
    private let disposeBag = DisposeBag()
    
    private let viewModel:TaskListResponser = TaskListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTaskVC = navC.viewControllers.first as? AddTaskVC else {
                  fatalError("Controller not found")
              }
        
        viewModel.updateTableView
            .subscribe(onNext: { [weak self] _ in
                self?.updateTableView()
            })
            .disposed(by: disposeBag)
        
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [weak self] task in
                let priority = Priority(rawValue: (self?.segmented.selectedSegmentIndex ?? 0))
                self?.viewModel.addTask(task: task, withPriority: priority)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex)
        self.viewModel.filterTasks(by: priority)
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
        return self.viewModel.getTotalTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell
        else { return UITableViewCell() }
        
        cell.taskName.text = self.viewModel.getTaskAtPosition(position: indexPath.row).title
        
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
    
}
