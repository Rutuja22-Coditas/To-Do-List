//
//  ToDoData.swift
//  To-Do List
//
//  Created by Coditas on 02/03/22.
//

import Foundation
import RealmSwift

struct ToDoData{
    var date : String
    var taskDetail : [TaskAndPriority]
}

struct TaskAndPriority {
    var priority : String
    var task : String
}

enum conditions{
    case edit
    case add
}

