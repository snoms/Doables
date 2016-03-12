//
//  DetailViewController.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var listID: Int!
    
//    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var listTitle: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var inputTodo: UITextField!
    
    @IBAction func clearList(sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete all To-dos? This can not be reverted.", preferredStyle: .Alert)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        let okAction = UIAlertAction(title: "Delete All", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
            TodoManager.sharedInstance.todolists[self.listID].clearList()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.inputTodo.resignFirstResponder()
        }
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(cancelAction)
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }

    var passedList: TodoList?
    let completedColor = UIColor(red: 0.10, green: 0.9, blue: 0.1, alpha: 0.15)
    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.title
//            }
//        }
        listTitle.title = TodoManager.sharedInstance.todolists[listID].getTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
//        print(TodoManager.sharedInstance.todolists[listID].getTodos()[0].getTitle())
//        print(TodoManager.sharedInstance.todolists[listID].getTodos()[0].getStatus())
//        TodoManager.sharedInstance.todolists[listID].getTodos()[0].toggleStatus()
//        print(TodoManager.sharedInstance.todolists[listID].getTodos()[0].getStatus())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func addTodo(sender: AnyObject) {
        if (inputTodo.text == "") {
            // Create the alert controller.
            let alert = UIAlertController(title: "You didn't enter anything!", message: "Insert your todo here or press OK to insert an empty row", preferredStyle: .Alert)
            
            // Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = ""
            })
            
            // Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                print("Text field: \(textField.text)")
//                if (textField.text?.characters.contains("^") == false) {
                TodoManager.sharedInstance.todolists[self.listID].addTodo(textField.text!)
//                    self.passedList!.addItem(textField.text!)
                    self.tableView.reloadData()
                TodoManager.sharedInstance.saveTodos()

//                    self.passedList!.save()
//                }
//                else {
//                    self.invalidChar()
//                }
            }))
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                self.inputTodo.resignFirstResponder()
            }            // Present the alert.
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            // alert: you have entered an empty todo. do you want to insert a white line?
            // if yes --> continue, if no --> abort
//            if (inputTodo.text?.characters.contains("^") == false) {
//                self.passedList!.addItem(inputTodo.text!)
//                print(passedList!.items)
                TodoManager.sharedInstance.todolists[self.listID].addTodo(inputTodo.text!)
                inputTodo.text = ""
                tableView.reloadData()
                TodoManager.sharedInstance.saveTodos()
                self.inputTodo.resignFirstResponder()
//            }
//            else {
//                invalidChar()
//            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listID != nil) {
            //if (listID) {
                return TodoManager.sharedInstance.todolists[listID].getTodos().count
            }
            else {
                return 0
            }
        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoCell
        cell.todoTextfield.text = TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row].getTitle()
        cell.layoutMargins = UIEdgeInsetsZero
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        print(indexPath.row)
        if TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row].getStatus() {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.backgroundColor = completedColor
            


        //    cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let todo = TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row]
        todo.toggleStatus()
        if todo.getStatus() {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.backgroundColor = completedColor
        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.backgroundColor = clearColor
        }
        TodoManager.sharedInstance.saveTodos()
    }
    
    func textFieldShouldReturn(inputTodo: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            TodoManager.sharedInstance.todolists[listID].removeTodo(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            TodoManager.sharedInstance.saveTodos()
        }
    }
}
