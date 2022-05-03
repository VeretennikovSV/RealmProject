//
//  Models.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import Foundation
import RealmSwift

class Tasks: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var isDone = false
    @Persisted var date = Date()
}
