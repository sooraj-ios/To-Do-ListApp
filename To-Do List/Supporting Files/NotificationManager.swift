//
//  NotificationManager.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UserNotifications
import CoreData

class NotificationManager {

    static let shared = NotificationManager()

    func scheduleTaskNotification(task: ToDoList) {
        let center = UNUserNotificationCenter.current()
        let notificationDate = Calendar.current.date(byAdding: .minute, value: -15, to: convertStringToDate(dateString: task.dueDate ?? ""))!
        guard notificationDate > Date() else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Your task \"\(task.title ?? "")\" is due soon."
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), repeats: false)
        let identifier = "TaskReminder-\(task.objectID.uriRepresentation().absoluteString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    func cancelTaskNotification(task: ToDoList) {
        let identifier = "TaskReminder-\(task.objectID.uriRepresentation().absoluteString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func convertStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
