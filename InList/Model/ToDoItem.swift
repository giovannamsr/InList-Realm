//
//  ToDoItem.swift
//  InList
//
//  Created by Giovanna Rodrigues on 13/10/21.
//

import Foundation
import RealmSwift

class ToDoItem: Object{
    
    @objc dynamic var taskDescription: String = ""
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var date: Date?
    
    var itemCategory = LinkingObjects(fromType: ToDoCategory.self, property: "items")
}
