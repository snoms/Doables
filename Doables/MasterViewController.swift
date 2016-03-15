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
    let completedColor = UIColor(red: 0.10, green: 0.9, blue: 0.1, alpha: 0.15)
    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        tableView.reloadData()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        let alert = UIAlertController(title: "New Todo list", message: "Please enter your list name here", preferredStyle: .Alert)
        // Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // Grab the value from the text field, and print it when the user clicks OK.
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let textField = alert.textFields![0] as UITextField
            let match = TodoManager.sharedInstance.findMatches(textField.text!)

            if match >= 0 {
                    //open DetailView with todolists[index]
                    self.segueGoal = match
                    self.performSegueWithIdentifier("showSpecificDetail", sender: self)
            }
            else if match == -1 {
                    self.newName = textField.text!
                    TodoManager.sharedInstance.newList(self.newName)
                    TodoManager.sharedInstance.saveTodos()
                    self.segueGoal = TodoManager.sharedInstance.todolists.count-1
                    self.performSegueWithIdentifier("showSpecificDetail", sender: self)
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }            // Present the alert.
        alert.addAction(addAction)
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
//                svc.passedList = object
                svc.listID = self.tableView.indexPathForSelectedRow?.row
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
            
            
        else if segue.identifier == "showSpecificDetail" {
            //if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = TodoManager.sharedInstance.todolists[segueGoal]
                let nav = segue.destinationViewController as! UINavigationController
                let svc = nav.topViewController as! DetailViewController
                svc.listID = segueGoal
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
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
        
        cell.textLabel!.numberOfLines = 1;
        cell.textLabel!.minimumScaleFactor = 8/UIFont.labelFontSize();
        cell.textLabel!.adjustsFontSizeToFitWidth = true;
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        cell.layoutMargins = UIEdgeInsetsZero
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        if TodoManager.sharedInstance.todolists[indexPath.row].getStatus() {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.backgroundColor = completedColor
        }
        if !TodoManager.sharedInstance.todolists[indexPath.row].getStatus() {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.backgroundColor = clearColor
        }
        
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


