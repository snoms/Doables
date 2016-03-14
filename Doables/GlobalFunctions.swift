//
//  GlobalFunctions.swift
//  Doables
//
//  Created by bob on 13/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

//import UIKit
//
//func textAlert(firstmessage: String, secondmessage: String, target: TodoList) {
//    
//    let alert = UIAlertController(title: firstmessage, message: secondmessage, preferredStyle: .Alert)
//    
//    // Add the text field. You can configure it however you need.
//    alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//        textField.text = ""
//    })
//    
//    // Grab the value from the text field, and print it when the user clicks OK.
//    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//        let textField = alert.textFields![0] as UITextField
//        print("Text field: \(textField.text)")
//        TodoManager.sharedInstance.target.addTodo(textField.text!)
//        self.tableView.reloadData()
//        TodoManager.sharedInstance.saveTodos()
//        
//    }))
//    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
//        UIAlertAction in
//        NSLog("Cancel Pressed")
//        self.resignFirstResponder()
//    }            // Present the alert.
//    alert.addAction(cancelAction)
//    self.presentViewController(alert, animated: true, completion: nil)
//}