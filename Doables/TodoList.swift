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
    private var completed: Bool

    init(title: String, todos: Array<TodoItem>, completed: Bool) {
        self.title = title
        self.todos = todos
        self.completed = completed
        
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "listTitle")
        aCoder.encodeObject(todos, forKey: "todosArray")
        aCoder.encodeBool(completed, forKey: "completedList")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("listTitle") as! String
        let todos = aDecoder.decodeObjectForKey("todosArray") as! Array<TodoItem>
        let completed = aDecoder.decodeBoolForKey("completedList")
        self.init(title: title, todos: todos, completed: completed)
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getTodos() -> Array<TodoItem> {
        return todos
    }
    
    func getStatus() -> Bool {
        for todo in self.todos {
            if !todo.getStatus() {
                return false
            }
        }
        return true
    }
    
    func completeItems() {
        for todo in self.todos {
            todo.setCompleted()
        }
    }
    
    func removeCompleted() {
        for (index, todo) in self.todos.enumerate().reverse() {
            if todo.getStatus() {
                removeTodo(index)
            }
        }
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