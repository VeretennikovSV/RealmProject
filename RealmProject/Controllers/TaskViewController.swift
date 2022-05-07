//
//  TaskViewController.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import UIKit
import RealmSwift

class TaskViewController: UITableViewController {
    
    private var completedTasks: Results<Task>!
    private var uncompletedTasks: Results<Task>!
    
    var tasks: Tasks!
    let cellId = "Task"
    
    var delegate: CheckLeftTasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))]
        
        self.title = tasks.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        filterTasks()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.check(tasks: tasks, tasksLeft: uncompletedTasks.count)
    }
    
    private func filterTasks() {
        completedTasks = tasks.tasks.filter("isDone = true")
        uncompletedTasks = tasks.tasks.filter("isDone = false")
    }
    
    @objc private func addNewTask() {
        showAlert(named: "Add new note")
    }
    
    func setTasks(tasks: Tasks) {
        self.tasks = tasks
    }
}

//MARK: TableView delegate, DataSourse
extension TaskViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Completed" : "To do"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? completedTasks.count : uncompletedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : uncompletedTasks[indexPath.row]
        content.text = task.name
        content.secondaryText = task.note
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : uncompletedTasks[indexPath.row]
        
        showAlert(named: "Edit Note", withTask: task, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : uncompletedTasks[indexPath.row]
        
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
                    to: IndexPath(row: self.uncompletedTasks.count - 1, section: 1))
            } else {
                self.tableView.moveRow(
                    at: indexPath,
                    to: IndexPath(row: self.completedTasks.count - 1, section: 0))
            }
            //Проверка готовности всех заданий
            if self.uncompletedTasks.isEmpty {
                StorageManager.shared.allNotesDone(in: self.tasks)
            } else {
                StorageManager.shared.notAllNotesDone(in: self.tasks)
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
extension TaskViewController {
    private func showAlert(named string: String, withTask task: Task? = nil, at indexPath: IndexPath? = nil) {
        let alert = AlertController.createAlert(with: string)
        alert.action(with: task, in: tasks) {
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
