//
//  ViewController.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import UIKit
import RealmSwift

protocol CheckLeftTasks {
    func check(tasks: Tasks, tasksLeft: Int)
}

class TasksListView: UIViewController, UITableViewDataSource, UITableViewDelegate, CheckLeftTasks {
    
    private var tableView: UITableView!
    
    private var segment: UISegmentedControl!
    
    var currentRows: [IndexPath] {
        var rows: [IndexPath] = []
        var currentRow = 0
        while currentRow < completed.count {
            rows.append(IndexPath(row: currentRow, section: 0))
            currentRow += 1
        }
        currentRow = 0
        while currentRow < uncompleted.count {
            rows.append(IndexPath(row: currentRow, section: 1))
        }
        return rows
    }
    
    var barHeight: CGFloat {
        guard let barHeight = navigationController?.navigationBar.frame.height else { return 0 }
        return barHeight
    }
    
    let realm = try! Realm()
    var listsOfTasks: Results<Tasks>!
    var completed: Results<Tasks>!
    var uncompleted: Results<Tasks>!
    
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listsOfTasks = StorageManager.shared.realm.objects(Tasks.self)
        
        view.backgroundColor = .white
        
        setupNavBar()
        setPreview()
        setEveryThing()
        filter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc private func addNewTask() {
        showAlert(with: "Add new Task")
    }
    
    private func setPreview() {
        DataManager.shared.createSomething {
            self.tableView.reloadData()
        }
    }
}


//MARK: TableView settings and delegate
extension TasksListView {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Completed tasks" : "Uncompleted tasks"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? completed.count : uncompleted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let taskList = indexPath.section == 0 ? completed[indexPath.row] : uncompleted[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = taskList.name
        
        if taskList.isAllDone {
            content.secondaryText = "Great job! You did it"
        } else {
            content.secondaryText = "Uncompleted tasks - \(taskList.tasksLeft)"
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tasks = indexPath.section == 0 ? completed[indexPath.row] : uncompleted[indexPath.row]
        
        //        showAlert(withTask: tasks, string: tasks.name, with: "Edit", indexPath: indexPath)
        
        let taskVC = TaskViewController()
        taskVC.setTasks(tasks: tasks)
        taskVC.delegate = self
        show(taskVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let tasks = indexPath.section == 0 ? completed[indexPath.row] : uncompleted[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: "delete") { _, _, isDone in
            isDone(true)
            
            StorageManager.shared.delete(tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let edit = UIContextualAction(style: .normal, title: "edit") { _, _, isDone in
            self.showAlert(withTask: tasks, with: "Edit task", indexPath: indexPath)
            isDone(true)
        }
        
        let allDone = UIContextualAction(style: .normal, title: "All Done") { _, _, isDone in
            isDone(true)
            StorageManager.shared.allDone(in: tasks)
            self.filter()
            if indexPath.section == 0 {
                let destination = IndexPath(row: self.uncompleted.count - 1, section: 1)
                self.tableView.moveRow(
                    at: indexPath,
                    to: destination)
                self.tableView.reloadRows(at: [destination], with: .automatic)
            } else {
                let destination = IndexPath(row: self.completed.count - 1, section: 0)
                self.tableView.moveRow(
                    at: indexPath,
                    to: destination)
                self.tableView.reloadRows(at: [destination], with: .automatic)
            }
        }
        
        tasks.isAllDone ? (allDone.backgroundColor = #colorLiteral(red: 0.06149461865, green: 0.6421864629, blue: 0, alpha: 1)) : (allDone.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
        if tasks.isAllDone {
            allDone.image = UIImage.createImageWith(name: "check", width: 25, height: 25)
        } else {
            allDone.image = UIImage.createImageWith(name: "x", width: 25, height: 25)
        }
        
        delete.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        delete.image = UIImage.createImageWith(name: "bin", width: 25, height: 25)
        
        edit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        edit.image = UIImage.createImageWith(name: "edit", width: 25, height: 25)
        
        return UISwipeActionsConfiguration(actions: [allDone, delete, edit])
    }
}

//MARK: Set UI
extension TasksListView {
    private func setEveryThing() {
        let segment = UISegmentedControl(items: ["One", "Two"])
        
        segment.sizeToFit()
        segment.tintColor = .black
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)],
            for: .normal)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segment)
        
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight + 50),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        segment.addTarget(self, action: #selector(segmentedControllSwitched(_:)), for: .valueChanged)
        
        self.segment = segment
        
        let tableView = UITableView()
        tableView.sizeToFit()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        self.tableView = tableView
    }
    
    private func setupNavBar() {
        title = "Tasks"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let navBarApearence = UINavigationBarAppearance()
        
        navBarApearence.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 0.8)
        navBarApearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))]
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarApearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApearence
    }
    
    func showAlert(withTask task: Tasks? = nil, with text: String, indexPath: IndexPath? = nil) {
        let alert = AlertController.createAlert(with: text)
        
        alert.action(with: task) {
            guard let _ = task else {
                self.tableView.insertRows(
                    at: [IndexPath(row: self.uncompleted.count - 1, section: 1)],
                    with: .automatic)
                return
            }
            guard let indexPath = indexPath else { return }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        present(alert, animated: true)
    }
}

extension TasksListView {
    private func filter() {
        completed = listsOfTasks.filter("isAllDone = true")
        uncompleted = listsOfTasks.filter("isAllDone = false")
    }
    
    func check(tasks: Tasks, tasksLeft: Int) {
        StorageManager.shared.tasksLeft(in: tasks, tasksLeft)
    }
    
    
    private func sortBy(_ howToSort: String) {
        let range = NSMakeRange(0, tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        
        listsOfTasks = realm.objects(Tasks.self).sorted(byKeyPath: "\(howToSort)", ascending: true)
        filter()
        tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    @objc private func segmentedControllSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0: sortBy("name")
            default: sortBy("date")
        }
    }
}
