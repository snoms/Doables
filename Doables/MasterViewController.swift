//
//  MasterViewController.swift
//  Doables
//
//  Created by bob on 10/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var listID: Int!
    var newName: String!
    var segueGoal: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        //let newTodoList = TodoManager.sharedInstance.newList("test")
        //objects.insert(newTodoList, atIndex: 0)
        //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let alert = UIAlertController(title: "New Todo list", message: "Please enter your list name here", preferredStyle: .Alert)
        // Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text!)")
            // strange bug here, detects duplicates after removal
//            for (index, lists) in TodoManager.sharedInstance.todolists.enumerate() {
//                if lists.getTitle() == textField.text {
//                    print("error: Duplicate list exists")
                    // open DetailView with todolists[index]
                    //self.segueGoal = index
//                    print(index)
                    //print(self.segueGoal)
                    //self.performSegueWithIdentifier("showSpecificDetail", sender: self)
//                }
//                else {
                    self.newName = textField.text!
                    print(self.newName)
                    TodoManager.sharedInstance.newList(self.newName)
                    print(TodoManager.sharedInstance.todolists.count)
                    TodoManager.sharedInstance.saveTodos()

//                }
//            }
            
            //self.objects.insert(newTodoList, atIndex: 0)
            //self.objects.append(newTodoList)
            //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.tableView.reloadData()
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }            // Present the alert.
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

        
        
    

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = TodoManager.sharedInstance.todolists[indexPath.row]
                let nav = segue.destinationViewController as! UINavigationController
                let svc = nav.topViewController as! DetailViewController
                svc.passedList = object
                svc.listID = self.tableView.indexPathForSelectedRow?.row
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if segue.identifier == "showSpecificDetail" {
            //if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[segueGoal] as! TodoList
                let nav = segue.destinationViewController as! UINavigationController
                let svc = nav.topViewController as! DetailViewController
                svc.passedList = object
                svc.listID = segueGoal
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            //}
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.sharedInstance.todolists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = TodoManager.sharedInstance.todolists[indexPath.row]
        cell.textLabel!.text = object.getTitle()
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            TodoManager.sharedInstance.todolists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print(TodoManager.sharedInstance.todolists.count)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

