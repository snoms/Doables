//
//  TodoManager.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation

class TodoManager: NSObject {
    
    static let sharedInstance = TodoManager()
    
    var todolists: Array<TodoList>
    
    private override init() {
        todolists = TodoManager.readTodos()!
        super.init()
    }
    
    func newList(listname: String) -> TodoList {
        var list = TodoList(title: listname, todos: [])
        TodoManager.sharedInstance.todolists.append(list)
        return list
    }
    
    class func readTodos() -> Array<TodoList>? {
        // read out TodoManager / todolists array from storage, return them
        let testitem = TodoItem(title: "testitem", completed: false)
        let testitem2 = TodoItem(title: "testitem2", completed: false)
        let testitemarray: Array<TodoItem> = [testitem!, testitem2!]
        let testitemarray2: Array<TodoItem> = [testitem2!, testitem!]
        let test = TodoList(title: "test", todos: testitemarray)
        let test2 = TodoList(title: "test2", todos: testitemarray2)
        return [test, test2]
    }
    
    class func saveTodos() {
        // encode TodoManager or todolists array into storage
    }

    
    
}