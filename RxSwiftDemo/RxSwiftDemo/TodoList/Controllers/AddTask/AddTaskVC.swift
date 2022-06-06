//
//  AddTaskVC.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 31/05/22.
//

import Foundation
import UIKit
import RxSwift

class AddTaskVC: UIViewController {
    
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var saveButton:UIBarButtonItem!
    @IBOutlet weak var cancelButton:UIBarButtonItem!
    @IBOutlet weak var taskNameTextField:UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.action = #selector(saveAction)
        saveButton.target = self
        
        cancelButton.action = #selector(cancelAction)
        cancelButton.target = self
        
        prioritySegmented.selectedSegmentIndex = 0
    }
    
    @objc public func cancelAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc public func saveAction() {
        guard let priority = Priority(rawValue: (prioritySegmented.selectedSegmentIndex + 1)),
              let taskName = taskNameTextField.text else {
                  return
              }

        let task = Task(title: taskName, priority: priority)
        taskSubject.onNext(task)

        cancelAction()
    }
    
}
