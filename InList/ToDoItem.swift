//
//  ToDoItem.swift
//  InList
//
//  Created by Giovanna Rodrigues on 08/10/21.
//

import Foundation

struct ToDoItem: Codable{
    
    var description: String
    var isCompleted = false
    
    init(description: String){
        self.description = description
    }
}
