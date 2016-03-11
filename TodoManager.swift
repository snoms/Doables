//
//  TodoManager.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    
    var todolists: Array<TodoList>
    
    static let dataPath = NSFileManager.defaultManager()
        .URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        .URLByAppendingPathComponent("data.plist").path!
    
    private init() {
        todolists = (NSKeyedUnarchiver.unarchiveObjectWithFile(TodoManager.dataPath) as? Array<TodoList>) ?? [] as Array<TodoList>
    }
    
    func newList(listname: String) -> TodoList {
        var list = TodoList(title: listname, todos: [])
        TodoManager.sharedInstance.todolists.append(list)
        return list
    }
//    
//    func readTodos() -> Array<TodoList>? {
////        // read out TodoManager / todolists array from storage, return them
////        let testitem = TodoItem(title: "testitem", completed: false)
////        let testitem2 = TodoItem(title: "testitem2", completed: false)
////        let testitemarray: Array<TodoItem> = [testitem!, testitem2!]
////        let testitemarray2: Array<TodoItem> = [testitem2!, testitem!]
////        let test = TodoList(title: "test", todos: testitemarray)
////        let test2 = TodoList(title: "test2", todos: testitemarray2)
////        return [test, test2]
//        return NSKeyedUnarchiver.unarchiveObjectWithFile(TodoManager.dataPath) as? Array<TodoList>
//    }
    
    func saveTodos() {
        // encode TodoManager or todolists array into storage
        NSKeyedArchiver.archiveRootObject(self.todolists, toFile: TodoManager.dataPath)
    }

    
    
}