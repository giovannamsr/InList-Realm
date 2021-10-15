//
//  Category.swift
//  InList
//
//  Created by Giovanna Rodrigues on 13/10/21.
//

import Foundation
import RealmSwift

class ToDoCategory: Object{
    
    @objc dynamic var categoryName: String = ""
    @objc dynamic var categoryColor: String = "#0000"
    
    let items = List<ToDoItem>()
}
