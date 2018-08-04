//
//  Project.swift
//  TodoList
//
//  Created by Bushmaks on 01.08.2018.
//  Copyright © 2018 Bushmaks. All rights reserved.
//

import Foundation

class Project {
    let title: String
    let id: Int
    var todos: [Todo]
    
    init(title: String, id: Int, todos: [Todo]) {
        self.title = title
        self.id = id
        self.todos = todos
    }
}
