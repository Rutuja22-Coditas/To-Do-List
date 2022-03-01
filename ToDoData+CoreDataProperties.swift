//
//  ToDoData+CoreDataProperties.swift
//  To-Do List
//
//  Created by Coditas on 01/03/22.
//
//

import Foundation
import CoreData


extension ToDoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoData> {
        return NSFetchRequest<ToDoData>(entityName: "ToDoData")
    }

    @NSManaged public var date: String?
    @NSManaged public var task: String?
    @NSManaged public var priority: String?

}

extension ToDoData : Identifiable {

}
