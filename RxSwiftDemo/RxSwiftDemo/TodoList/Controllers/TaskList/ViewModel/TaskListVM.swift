//
//  TaskListVM.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 05/06/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol TaskListInputs {
    func addTask(task:Task, withPriority priority:Priority?)
    func filterTasks(by priority:Priority?)
}

protocol TaskListOutputs {
    var updateTableView:PublishSubject<Void> { get set }
    func getTotalTasks() -> Int
    func getTaskAtPosition(position:Int) -> Task
}

protocol TaskListResponser: TaskListInputs, TaskListOutputs { }

class TaskListVM: TaskListResponser {
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var tasksArray = [Task]()
    private let disposeBag = DisposeBag()
    
    var updateTableView = PublishSubject<Void>()
    
    internal func addTask(task:Task, withPriority priority:Priority?) {
        var existingTasks = self.tasks.value
        existingTasks.append(task)
        self.tasks.accept(existingTasks)
        self.filterTasks(by: priority)
    }
    
    internal func filterTasks(by priority:Priority?) {
        if priority == nil {
            self.tasksArray = self.tasks.value
            self.updateTableView.onNext(())
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.tasksArray = tasks
                self?.updateTableView.onNext(())
            }).disposed(by: disposeBag)
        }
    }
    
    func getTotalTasks() -> Int {
        return tasksArray.count
    }
    
    func getTaskAtPosition(position:Int) -> Task {
        return tasksArray[position]
    }
}
