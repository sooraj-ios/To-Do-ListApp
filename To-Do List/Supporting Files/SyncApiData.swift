//
//  SyncApiData.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import Foundation
import CoreData

class SyncApiData {
    static let shared = SyncApiData()

    // Sync tasks with the mock API
    func syncTasksWithAPI() {
        guard NetworkManager.shared.isConnected else {
            print("Offline. Cannot sync.")
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.fetchTasksFromAPI { [weak self] fetchedTasks in
                self?.mergeTasksWithLocalData(fetchedTasks)
            }
        }
    }

    // Simulate fetching tasks from a mock API (local JSON file)
    private func fetchTasksFromAPI(completion: @escaping ([TaskModel]) -> Void) {
        guard let url = Bundle.main.url(forResource: "ApiData", withExtension: "json") else {
            completion([])
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let tasks = try JSONDecoder().decode([TaskModel].self, from: data)
            completion(tasks)
        } catch {
            completion([])
        }
    }

    // Merge fetched tasks with local Core Data
    private func mergeTasksWithLocalData(_ fetchedTasks: [TaskModel]) {
        let localTasks = CoreDataManager.shared.fetchTasks()

        // Simple merge logic: replace local tasks with fetched ones
        for fetchedTask in fetchedTasks {
            if let existingTask = localTasks.first(where: { $0.title == fetchedTask.title }) {
                // Update existing task
                existingTask.desc = fetchedTask.desc
                existingTask.dueDate = fetchedTask.dueDate
                existingTask.priority = fetchedTask.priority
            } else {
                // Create new task
                CoreDataManager.shared.createTask(
                    title: fetchedTask.title,
                    desc: fetchedTask.desc,
                    dueDate: fetchedTask.dueDate,
                    priority: fetchedTask.priority,
                    index: fetchedTask.index
                )
            }
        }

//        // Optionally, delete local tasks not found in fetched tasks
//        for localTask in localTasks {
//            if !fetchedTasks.contains(where: { $0.title == localTask.title }) {
//                CoreDataManager.shared.deleteTask(task: localTask)
//            }
//        }
    }
}
