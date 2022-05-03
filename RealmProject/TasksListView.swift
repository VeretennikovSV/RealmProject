//
//  ViewController.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import UIKit
import RealmSwift

class TasksListView: UITableViewController {

    var listsOfTasks: Results<Tasks>!
    
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.backgroundColor = .white
        setupNavBar()
        
        setPreview()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        addSegment()
        
    }
    private func setupNavBar() {
        title = "Tasks"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    private func addSegment() {
        let segment = UISegmentedControl(items: ["One", "Two"])
        
        segment.sizeToFit()
        segment.tintColor = .black
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)],
            for: .normal)
        
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(segment)
        
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIScreen.main.bounds.width)
        ])
    }
    
    @objc private func addNewTask() {
        
    }
    
    private func setPreview() {
        DataManager.shared.createSomething {
            self.tableView.reloadData()
        }
    }

}


//MARK: TableView settings and delegate
extension TasksListView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listsOfTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let taskList = listsOfTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = taskList.name
        
        return cell
    }
}
