//
//  TaskView.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import UIKit
import RealmSwift

class TaskView: UITableViewController {
    
    private var completedTasks: Results<Task>!
    private var uncompletedTasks: Results<Task>!
    
    var viewModel: TaskViewModel! {
        didSet {
            self.title = viewModel.tasks.name
            viewModel.filterTasks()
            self.tableView.reloadData()
        }
    }
    
    var tasks: Tasks!
    
    var delegate: CheckLeftTasks!
    
    private let cellId = "Task"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TaskViewModel(tasks: tasks)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.check(tasks: viewModel.tasks, tasksLeft: viewModel.uncompletedTasks.count)
    }
    
    private func filterTasks() {
        viewModel.filterTasks()
    }
    
    @objc private func addNewTask() {
        showAlert(named: "Add new note")
    }
}

//MARK: TableView delegate, DataSourse
extension TaskView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleOfSec(in: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellForTasks

        cell.viewModel = viewModel.cellForRowAt(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = indexPath.section == 0 ? viewModel.completedTasks[indexPath.row] : viewModel.uncompletedTasks[indexPath.row]
        
        showAlert(named: "Edit Note", withTask: task, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? viewModel.completedTasks[indexPath.row] : viewModel.uncompletedTasks[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: "delte") { _, _, isDone in
            isDone(true)
            StorageManager.shared.delete(note: task)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let edit = UIContextualAction(style: .normal, title: "edit") { _, _, isDone in
            self.showAlert(named: "Edit", withTask: task, at: indexPath)
            isDone(true)
        }
        
        let done = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            isDone(true)
            StorageManager.shared.noteDone(task)
            self.filterTasks()
            
            if indexPath.section == 0 {
                self.tableView.moveRow(
                    at: indexPath,
                    to: IndexPath(row: self.viewModel.uncompletedTasks.count - 1, section: 1))
            } else {
                self.tableView.moveRow(
                    at: indexPath,
                    to: IndexPath(row: self.viewModel.completedTasks.count - 1, section: 0))
            }
            
            //Проверка готовности всех заданий
            if self.uncompletedTasks.isEmpty {
                StorageManager.shared.allNotesDone(in: self.viewModel.tasks)
            } else {
                StorageManager.shared.notAllNotesDone(in: self.viewModel.tasks)
            }
        }
        
        delete.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        delete.image = UIImage.createImageWith(name: "bin", width: 25, height: 25)
        
        edit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        edit.image = UIImage.createImageWith(name: "edit", width: 25, height: 25)
        
        task.isDone ? (done.backgroundColor = #colorLiteral(red: 0.06149461865, green: 0.6421864629, blue: 0, alpha: 1)) : (done.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
        
        if task.isDone {
            done.image = UIImage.createImageWith(name: "check", width: 25, height: 25)
        } else {
            done.image = UIImage.createImageWith(name: "x", width: 25, height: 25)
        }
        
        return UISwipeActionsConfiguration(actions: [done, delete, edit])
    }
}

//MARK: AlertController
extension TaskView {
    private func showAlert(named string: String, withTask task: Task? = nil, at indexPath: IndexPath? = nil) {
        let alert = AlertController.createAlert(with: string)
        alert.action(with: task, in: viewModel.tasks) {
            guard let _ = task else {
                self.tableView.insertRows(
                    at: [IndexPath(row: self.uncompletedTasks.count - 1, section: 1)],
                    with: .automatic)
                return
            }
            guard let indexPath = indexPath else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        present(alert, animated: true)
    }
}
