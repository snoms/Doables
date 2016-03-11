//
//  TodoList.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation

class TodoList: NSObject, NSCoding {
    
    private var title: String
    private var todos: Array<TodoItem>
    
//    static let listTitle = "listTitle"
//    static let todosArray = "todosArray"

    init(title: String, todos: Array<TodoItem>) {
        self.title = title
        self.todos = todos
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "listTitle")
        aCoder.encodeObject(todos, forKey: "todosArray")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("listTitle") as! String
        let todos = aDecoder.decodeObjectForKey("todosArray") as! Array<TodoItem>
        self.init(title: title, todos: todos)
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getTodos() -> Array<TodoItem> {
        return todos
    }
    
    func addTodo(text: String) {
        let todo = TodoItem(title: text, completed: false)
        todos.append(todo!)
    }
    
    func removeTodo(todoid: Int) {
        todos.removeAtIndex(todoid)
    }
    
    func clearList() {
        todos.removeAll()
    }
    
}