//
//  TaskViewMoldel.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 11/06/2022.
//

import Foundation
import RealmSwift

protocol TaskViewModelProtocol {
    var completedTasks: Results<Task>! { get }
    var uncompletedTasks: Results<Task>! { get }
    
    var tasks: Tasks { get }
    
    func filterTasks()
    func numberOfRows(in sec: Int) -> Int
    func titleOfSec(in sec: Int) -> String
    func cellForRowAt(indexPath: IndexPath) -> CellForTaskProtocol
}

class TaskViewModel: TaskViewModelProtocol {
    var completedTasks: Results<Task>!
    var uncompletedTasks: Results<Task>!
    
    var tasks: Tasks
    
    init(tasks: Tasks) {
        self.tasks = tasks
    }
    
    func filterTasks() {
        completedTasks = tasks.tasks.filter("isDone = true")
        uncompletedTasks = tasks.tasks.filter("isDone = false")
    }
    
    func numberOfRows(in sec: Int) -> Int {
        sec == 0 ? completedTasks.count : uncompletedTasks.count
    }
    
    func titleOfSec(in sec: Int) -> String {
        sec == 0 ? "Completed" : "To do"
    }
    
    func cellForRowAt(indexPath: IndexPath) -> CellForTaskProtocol {
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : uncompletedTasks[indexPath.row]
        
        return CellForTaskViewModel(task: task)
    }
}
