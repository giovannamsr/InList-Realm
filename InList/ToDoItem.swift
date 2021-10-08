//
//  ToDoItem.swift
//  InList
//
//  Created by Marcelo Rodrigues de Sousa on 08/10/21.
//

import Foundation

struct ToDoItem{
    
    var description: String
    var isCompleted = false
    
    init(description: String){
        self.description = description
    }
}
