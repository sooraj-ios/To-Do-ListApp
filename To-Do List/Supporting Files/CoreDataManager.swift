//
//  CoreDataManager.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "To_Do_List")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    // MARK: - Create Task
    func createTask(title: String, desc: String, dueDate: String, priority: String, index:Int64) {
        let context = persistentContainer.viewContext
        let task = ToDoList(context: context)
        task.title = title
        task.desc = desc
        task.dueDate = dueDate
        task.priority = priority
        task.index = index
        saveContext()
        NotificationManager.shared.scheduleTaskNotification(task: task)
    }

    // MARK: - Fetch All Tasks
    func fetchTasks() -> [ToDoList] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    // MARK: - Delete Task
    func deleteTask(task: ToDoList) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
        NotificationManager.shared.cancelTaskNotification(task: task)
    }

    // MARK: - Update All Task Indexes
    func updateAllTaskIndexes(currentArray: [TaskModel]) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            for (index, task) in tasks.enumerated() {
                for item in currentArray{
                    if task.title == item.title {
                        task.index = item.index
                    }
                }
            }
            try context.save()
        } catch {
            print("Failed to update task indexes: \(error)")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
