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
        try! realm.write {
            realm.add(taskList)
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
            print(1)
        }
    }
    
    private init() {}
}
