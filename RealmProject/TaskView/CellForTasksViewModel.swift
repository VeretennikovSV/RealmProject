//
//  CellForTasksViewModel.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 11/06/2022.
//

import Foundation

protocol CellForTaskProtocol {
    var name: String { get }
    var note: String { get }
    var viewModelDidChange: ((CellForTaskProtocol) -> Void)? { get set }
    init(task: Task)
}

class CellForTaskViewModel: CellForTaskProtocol {
    var viewModelDidChange: ((CellForTaskProtocol) -> Void)?
    
    private let task: Task!
    
    var name: String {
        task.name
    }
    
    var note: String {
        task.note
    }
    
    required init(task: Task) {
        self.task = task
    }
}
