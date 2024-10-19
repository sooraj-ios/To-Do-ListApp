//
//  AppController.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class AppStoryBoard {

   static let shared = AppStoryBoard()

    var main:UIStoryboard {
       UIStoryboard(name: "Main", bundle: nil)
    }
}

class AppController {

    static let shared = AppController()

    // MARK: - Authentication
    var launch: LaunchVC {
       AppStoryBoard.shared.main.instantiateViewController(withIdentifier: "LaunchVC_id") as? LaunchVC ?? LaunchVC()
    }

    var toDoList: ToDoListVC {
       AppStoryBoard.shared.main.instantiateViewController(withIdentifier: "ToDoListVC_id") as? ToDoListVC ?? ToDoListVC()
    }

    var addNewTask: AddNewTaskVC {
       AppStoryBoard.shared.main.instantiateViewController(withIdentifier: "AddNewTaskVC_id") as? AddNewTaskVC ?? AddNewTaskVC()
    }
}

