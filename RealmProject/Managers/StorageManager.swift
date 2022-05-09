//
//  StorageManager.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import RealmSwift


class StorageManager {
    static var shared = StorageManager()
    
    let realm = try! Realm()

    func save(_ taskList: Tasks) {
        write {
            realm.add(taskList)
        }
    }
    
    func save(with task: Tasks) {
        write {
            realm.add(task)
        }
    }
    
    func saveNote(in tasks: Tasks, with text: String, and note: String?) {
        write {
            let task = Task()
            task.name = text
            task.note = note ?? ""
            tasks.tasks.append(task)
            tasks.isAllDone = false
        }
    }
    
    func noteDone(_ note: Task) {
        write {
            note.isDone.toggle()
        }
    }
    
    func delete(note: Task) {
        write {
            realm.delete(note)
        }
    }
    
    func allDone(in tasks: Tasks) {
        write {
            tasks.isAllDone.toggle()
            tasks.tasks.forEach { task in
                task.isDone = true
            }
            tasks.tasksLeft = 0
        }
    }
    
    func allNotesDone(in tasks: Tasks) {
        write {
            tasks.isAllDone = true
        }
    }
    
    func notAllNotesDone(in tasks: Tasks) {
        write {
            tasks.isAllDone = false
        }
    }
    
    func editNote(in task: Task, with text: String, and note: String?) {
        write {
            task.name = text
            task.note = note ?? ""
        }
    }
    
    func edit(task tasks: Tasks, with text: String) {
        write {
            tasks.name = text
        }
    }
    
    func tasksLeft(in tasks: Tasks, _ count: Int) {
        write {
            tasks.tasksLeft = count
        }
    }
    
    func delete(_ taskList: Tasks) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    
    private func write(completion: () -> ()) {
        do {
            try realm.write{
                completion()
            }
        } catch {
            print("Can't enter in realm")
        }
    }
    
    private init() {}
}
