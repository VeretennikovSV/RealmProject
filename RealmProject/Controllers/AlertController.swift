//
//  AlertController.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 06/05/2022.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    static func createAlert(with string: String) -> AlertController {
        return AlertController(title: string, message: "What we do?", preferredStyle: .alert)
    }
    
    func action(with task: Tasks? = nil, completion: @escaping () -> ()) {
        
        let alertOk = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let text = self.textFields?.first?.text, text != "" else { return }
            
            if let task = task {
                StorageManager.shared.edit(task: task, with: text)
            } else {
                let task = Tasks()
                task.name = text
                StorageManager.shared.save(with: task)
            }
            completion()
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        self.addAction(alertOk)
        self.addAction(alertCancel)
        self.addTextField { tf in
            tf.placeholder = "Your task"
            if task != nil { tf.text = task?.name }
        }
    }
    
    func action(with task: Task? = nil, in tasks: Tasks, completion: @escaping () -> ()) {
        
        let alertOk = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let text = self.textFields?.first?.text, text != "" else { return }
            let note = self.textFields?[1].text
            
            if let task = task {
                StorageManager.shared.editNote(in: task, with: text, and: note)
            } else {
                StorageManager.shared.saveNote(in: tasks, with: text, and: note)
            }
            completion()
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        self.addAction(alertOk)
        self.addAction(alertCancel)
        self.addTextField { tf in
            tf.placeholder = "Your task"
            if task != nil { tf.text = task?.name }
        }
        self.addTextField { tf in
            tf.placeholder = "Note"
            if task != nil { tf.text = task?.note }
        }
    }
}
