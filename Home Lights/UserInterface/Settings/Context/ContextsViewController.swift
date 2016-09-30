//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit
import Foundation

class IndexedUITextField: UITextField
{
    var index: Int = 0
}

class ContextTableViewCell: UITableViewCell
{
    @IBOutlet var nameLabel: IndexedUITextField!
}

class ContextsViewController: UITableViewController, UITextFieldDelegate
{
    var client: Client!
    var context: Context!
    
    var addContextButton: UIBarButtonItem!
    var removeContextButton: UIBarButtonItem!
    var loadContextButton: UIBarButtonItem!
    var saveContextButton: UIBarButtonItem!
    
    var flexibleSpace: UIBarButtonItem!
    
    var activeField: UITextField?
    
    override func viewDidLoad()
    {
        navigationItem.title = "Favorites"
        
        initButtons()
    
        self.setToolbarItems([addContextButton, flexibleSpace, removeContextButton, flexibleSpace, loadContextButton, flexibleSpace, saveContextButton], animated: true)
    }
    
    func initButtons()
    {
        let lr = (navigationController?.toolbar.frame.height)!*0.8
        let tl = (navigationController?.toolbar.frame.height)!-lr
        
        let addContextBtn = UIButton()
        addContextBtn.setImage(UIImage(named: "AddContext"), forState: .Normal)
        addContextBtn.frame = CGRectMake(tl, tl, lr, lr)
        addContextBtn.addTarget(self, action: #selector(ContextsViewController.addContext), forControlEvents: .TouchUpInside)
        addContextButton = UIBarButtonItem(customView: addContextBtn)
        
        let removeContextBtn = UIButton()
        removeContextBtn.setImage(UIImage(named: "RemoveContext"), forState: .Normal)
        removeContextBtn.frame = CGRectMake(tl, tl, lr, lr)
        removeContextBtn.addTarget(self, action: #selector(ContextsViewController.removeContext), forControlEvents: .TouchUpInside)
        removeContextButton = UIBarButtonItem(customView: removeContextBtn)
        
        let loadContextBtn = UIButton()
        loadContextBtn.setImage(UIImage(named: "LoadContext"), forState: .Normal)
        loadContextBtn.frame = CGRectMake(tl, tl, lr, lr)
        loadContextBtn.addTarget(self, action: #selector(ContextsViewController.loadContext), forControlEvents: .TouchUpInside)
        loadContextButton = UIBarButtonItem(customView: loadContextBtn)
        
        let saveContextBtn = UIButton()
        saveContextBtn.setImage(UIImage(named: "SaveContext"), forState: .Normal)
        saveContextBtn.frame = CGRectMake(tl, tl, lr, lr)
        saveContextBtn.addTarget(self, action: #selector(ContextsViewController.saveContext), forControlEvents: .TouchUpInside)
        saveContextButton = UIBarButtonItem(customView: saveContextBtn)
        
        
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    func addContext()
    {
        context.add()
        
        tableView.reloadData()
    }
    
    func removeContext()
    {
        if(tableView.editing)
        {
            tableView.setEditing(false, animated: true)
            (removeContextButton.customView as! UIButton).setImage(UIImage(named: "RemoveContext"), forState: .Normal)
        }
        else
        {
            tableView.setEditing(true, animated: true)
            (removeContextButton.customView as! UIButton).setImage(UIImage(named: "RemoveContextDone"), forState: .Normal)
        }
    }
    
    func loadContext()
    {
        if context.entries.count == 0
        {
            dispatch_async(dispatch_get_main_queue())
            {
                let popup: UIAlertController = UIAlertController(title: "Load context", message: "There is no context to load.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil);
                popup.addAction(ok)
                
                self.presentViewController(popup, animated: true, completion: nil)
            }
            return
        }

        let index = self.tableView.indexPathForSelectedRow?.row
        
        if index == nil
        {
            dispatch_async(dispatch_get_main_queue())
            {
                let popup: UIAlertController = UIAlertController(title: "Load context", message: "Select context to load.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil);
                popup.addAction(ok)
                
                self.presentViewController(popup, animated: true, completion: nil)
            }
            return
        }
        
        dispatch_async(dispatch_get_main_queue())
        {
            let entry = self.context.entries[index!]
            
            let popup: UIAlertController = UIAlertController(title: "Load context", message: "Do you want to load \(entry.name) ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:
            {
                _ in
                
                self.context.load(index!)
                for device in self.context.devices
                {
                    self.client.publishColor(device.color, topic: device.topic, callback: {_ in })
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            });
            
            let skip: UIAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil);
            
            popup.addAction(action)
            popup.addAction(skip)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    func saveContext()
    {
        if context.entries.count == 0
        {
            context.add()
            context.save(0)
            
            tableView.reloadData()
            
            return
        }
     
        let index = self.tableView.indexPathForSelectedRow?.row
     
        if index == nil
        {
            dispatch_async(dispatch_get_main_queue())
            {
                let popup: UIAlertController = UIAlertController(title: "Save context", message: "Select context to save.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil);
                popup.addAction(ok)
                
                self.presentViewController(popup, animated: true, completion: nil)
            }
            return
        }
        
        dispatch_async(dispatch_get_main_queue())
        {
            let entry = self.context.entries[index!]
            
            let popup: UIAlertController = UIAlertController(title: "Save context", message: "Do you want to save \(entry.name) ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:
            {
                    (alert: UIAlertAction!) in
                    
                    self.context.save(index!)
                    self.dismissViewControllerAnimated(true, completion: nil)
            });
            
            let skip: UIAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil);
            
            popup.addAction(action)
            popup.addAction(skip)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return context.entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let index = indexPath.row
        let cellIdentifier = "ColorSetTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContextTableViewCell
        let entry = context.entries[index]
        
        cell.nameLabel.text = entry.name
        cell.nameLabel.delegate = self
        cell.nameLabel.index = index
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            context.entries.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert { }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if activeField != nil
        {
            activeField!.resignFirstResponder()
            activeField = nil
        }
        
        let field = textField as! IndexedUITextField
        let selectedIndex = tableView.indexPathForSelectedRow
        
        if selectedIndex == nil || selectedIndex?.row != field.index
        {
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: field.index, inSection: 0), animated: false, scrollPosition: .None)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        let field = textField as! IndexedUITextField
        context.entries[field.index].name = field.text!
        
        activeField = nil
    }
}
