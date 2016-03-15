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
    weak var AddAlertSaveAction: UIAlertAction?
    let completedColor = UIColor(red: 0.10, green: 0.9, blue: 0.1, alpha: 0.15)
    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    @IBOutlet weak var listTitle: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func clearList(sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete all completed To-dos? This can not be reverted.", preferredStyle: .Alert)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        let okAction = UIAlertAction(title: "Delete All", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
            TodoManager.sharedInstance.todolists[self.listID].removeCompleted()
            TodoManager.sharedInstance.saveTodos()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.resignFirstResponder()
        }
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(cancelAction)
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }

    @IBAction func markAllComplete(sender: AnyObject) {
        TodoManager.sharedInstance.todolists[listID].completeItems()
        tableView.reloadData()
        TodoManager.sharedInstance.saveTodos()
    }
 
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
        self.title = TodoManager.sharedInstance.todolists[listID].getTitle()
//        let tlabel = UILabel(frame: CGRectZero)
//        tlabel.numberOfLines = 0
//        //tlabel.font = UIFont(name: "HelveticaNeue-Thin", size: 26.0)
//        tlabel.adjustsFontSizeToFitWidth = true
//        tlabel.text = self.navigationItem.title
//        self.navigationItem.titleView = tlabel
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func todoAlert(type: String, indexPath: NSIndexPath?, todo: String?) {
        // http://stackoverflow.com/questions/24474762/check-on-uialertcontroller-textfield-for-enabling-the-button
        let title = NSLocalizedString("", comment: "")
        let message = NSLocalizedString("", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("Save", comment: "")
        
        let todoIndex = indexPath?.row
        
        var alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if (type == "new") {
            let title = NSLocalizedString("New Item", comment: "")
            let message = NSLocalizedString("Insert your Todo.", comment: "")
            alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        }
        if (type == "edit") {
            let title = NSLocalizedString("Edit Item", comment: "")
            let message = NSLocalizedString("Edit your Todo.", comment: "")
            let todo = todo
            alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        }
        
        // Add the text field with handler
        if (type == "new") {
        alertController.addTextFieldWithConfigurationHandler { textField in
            //listen for changes
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: textField)
            }
        }
        if (type == "edit") {
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = todo
            })
        }
        
        func removeTextFieldObserver() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alertController.textFields![0])
        }
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("Cancel Button Pressed")
            removeTextFieldObserver()
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .Default) { action in
            NSLog("Save Button Pressed")
            if (type == "new") {
                let textField = alertController.textFields![0] as UITextField
                TodoManager.sharedInstance.todolists[self.listID].addTodo(textField.text!)
                self.tableView.reloadData()
                TodoManager.sharedInstance.saveTodos()
                removeTextFieldObserver()
            }
            if (type == "edit") {
                TodoManager.sharedInstance.todolists[self.listID].getTodos()[todoIndex!].editTitle(alertController.textFields![0].text!)
                self.tableView.reloadData()
                TodoManager.sharedInstance.saveTodos()
                removeTextFieldObserver()
            }
        }

        // disable the 'Save' button initially
        otherAction.enabled = false
        if (type == "edit") {
            otherAction.enabled = true
        }
        
        // save the other action to toggle the enabled/disabled state when the text changed.
        AddAlertSaveAction = otherAction
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        presentViewController(alertController, animated: true, completion: nil)
        }
    
    @IBAction func addTodo(sender: AnyObject) {
//      http://stackoverflow.com/questions/24474762/check-on-uialertcontroller-textfield-for-enabling-the-button
        todoAlert("new", indexPath: nil, todo: nil)
    }
        
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.enabled = textField.text?.characters.count >= 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listID != nil) {
                return TodoManager.sharedInstance.todolists[listID].getTodos().count
            }
            else {
                return 0
            }
        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoCell
        cell.todoTextfield.text = TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row].getTitle()
        
        cell.todoTextfield.numberOfLines = 1;
        cell.todoTextfield.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.todoTextfield.adjustsFontSizeToFitWidth = true;
        cell.todoTextfield.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        cell.layoutMargins = UIEdgeInsetsZero
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        if TodoManager.sharedInstance.todolists[listID].getTodos()[indexPath.row].getStatus() {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.backgroundColor = completedColor
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.backgroundColor = clearColor
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
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            TodoManager.sharedInstance.todolists[listID].removeTodo(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//            TodoManager.sharedInstance.saveTodos()
//        }
//    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            TodoManager.sharedInstance.todolists[self.listID].removeTodo(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            TodoManager.sharedInstance.saveTodos()
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            // edit item at indexPath
            print("edit pressed")
            let todoEdit = TodoManager.sharedInstance.todolists[self.listID].getTodos()[indexPath.row].getTitle()
            self.todoAlert("edit", indexPath: indexPath, todo: todoEdit)
            
        }
        
        edit.backgroundColor = self.view.tintColor
        
        return [delete, edit]
    }
}
