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
}

