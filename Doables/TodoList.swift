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
//    private var completedCount: Int
    
//    static let listTitle = "listTitle"
//    static let todosArray = "todosArray"

    init(title: String, todos: Array<TodoItem>, completed: Bool) {
        self.title = title
        self.todos = todos
//        self.completedCount = completedCount
        self.completed = completed
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "listTitle")
        aCoder.encodeObject(todos, forKey: "todosArray")
//        aCoder.encodeObject(completedCount as Int, forKey: "completedCount")
        aCoder.encodeBool(completed, forKey: "completedList")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("listTitle") as! String
        let todos = aDecoder.decodeObjectForKey("todosArray") as! Array<TodoItem>
//        let completedCount = aDecoder.decodeObjectForKey("completedCount") as! Int
        let completed = aDecoder.decodeBoolForKey("completedList")
        self.init(title: title, todos: todos, completed: completed)
//        if self.completedCount == self.todos.count {
//            self.completed = true
//        }
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
            else {
                return true
            }
        }
        return false
    }
    
//    func getCompleted() -> Int {
//        return completedCount
//    }
//    
//    func changeCompleted(value: Int) {
//        self.completedCount += value
//    }
//    
//    func setStatus(status: Bool) {
//        self.completed = status
//    }
    
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