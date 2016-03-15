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
        var list = TodoList(title: listname, todos: [], completed: false)
        TodoManager.sharedInstance.todolists.append(list)
        return list
    }
 
    func findMatches(title: String) -> (Int) {
        for (index, list) in todolists.enumerate() {
            if list.getTitle() == title {
                return (index)
            }
        }
        return (-1)
    }
    
    func saveTodos() {
        // encode TodoManager or todolists array into storage
        NSKeyedArchiver.archiveRootObject(self.todolists, toFile: TodoManager.dataPath)
    }

    
    
}