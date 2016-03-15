//
//  TodoItem.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation

class TodoItem: NSObject, NSCoding {
    
    private var title: String
    private var completed = false
    
    init?(title: String, completed: Bool) {
        self.title = title
        self.completed = completed
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "itemTitle")
        aCoder.encodeBool(completed, forKey: "itemStatus")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("itemTitle") as! String
        let completed = aDecoder.decodeBoolForKey("itemStatus") 
        self.init(title: title, completed: completed)
    }
    
    func getTitle() -> String {
        return title
    }
    
    func editTitle(newtitle: String) {
        self.title = newtitle
    }
    
    func getStatus() -> Bool {
        return completed
    }
    
    func toggleStatus() {
        completed = !completed
    }
    
    func setCompleted() {
        completed = true
    }
    
}