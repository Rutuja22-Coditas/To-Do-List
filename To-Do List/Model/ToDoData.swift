//
//  ToDoData.swift
//  To-Do List
//
//  Created by Coditas on 02/03/22.
//

import Foundation

struct ToDoData{
    var date : Date
    var priority : String
    var task : String
}

var toDoDataArray = [ToDoData]()
let dateFormatter = DateFormatter()
