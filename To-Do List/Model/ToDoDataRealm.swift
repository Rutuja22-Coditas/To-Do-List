//
//  ToDoDataRealm.swift
//  To-Do List
//
//  Created by Coditas on 02/03/22.
//

import Foundation
import RealmSwift

class Task : Object{
    @objc dynamic var taskId : String?
    @objc dynamic var taskCompleted : Bool = false
    @objc dynamic var task : String?
    @objc dynamic var priority : String?
    @objc dynamic var date : Date?
    
    override class func primaryKey() -> String? {
        return "taskId"
    }
}
