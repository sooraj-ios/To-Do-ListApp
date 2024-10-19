//
//  ToDoListVM.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit
import CoreData

class ToDoListVM {
    var isLoadingData: Observable<Bool> = Observable(false)
    var showError: Observable<String> = Observable(nil)
    var taskItems: Observable<[TaskModel]> = Observable(nil)

    func fetchTasks(){
        let tasks = CoreDataManager.shared.fetchTasks()
        let convertedTask = tasks.map({ TaskModel(id: $0.id ?? "", index: $0.index, title: $0.title ?? "", desc: $0.desc ?? "", dueDate: $0.dueDate ?? "", priority: $0.priority ?? "")})
        taskItems.value = convertedTask.sorted(by: {$0.index < $1.index})
    }
}

