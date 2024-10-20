//
//  TaskModel.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

struct TaskModel : Decodable{
    var id: String
    var index: Int64
    var title: String
    var desc: String
    var dueDate: String
    var priority: String
}
