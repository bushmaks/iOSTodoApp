//
//  Todos.swift
//  TodoList
//
//  Created by Bushmaks on 01.08.2018.
//  Copyright © 2018 Bushmaks. All rights reserved.
//

import Foundation

class Todo {
    let id: Int
    let text: String
    var isCompleted: Bool
    let project_id: Int
    
    
    init(id: Int, text: String, isCompleted: Bool, project_id: Int) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.project_id = project_id
    }
}
