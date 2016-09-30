//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit

class DevicesViewController: UITableViewController
{
    var context: Context!
    
    var addDeviceButton: UIBarButtonItem!
    var removeDeviceButton: UIBarButtonItem!
    var flexibleSpace: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        navigationItem.title = "Devices"
        
        initButtons()
        
        self.setToolbarItems([addDeviceButton, flexibleSpace, removeDeviceButton], animated: true)
    }
    
    func initButtons()
    {
        let lr = (navigationController?.toolbar.frame.height)!*0.8
        let tl = (navigationController?.toolbar.frame.height)!-lr
        
        let addDeviceBtn = UIButton()
        addDeviceBtn.setImage(UIImage(named: "AddDevice"), forState: .Normal)
        addDeviceBtn.frame = CGRectMake(tl, tl, lr, lr)
        addDeviceBtn.addTarget(self, action: #selector(DevicesViewController.editItemSegue), forControlEvents: .TouchUpInside)
        addDeviceButton = UIBarButtonItem(customView: addDeviceBtn)
        
        let removeDeviceBtn = UIButton()
        removeDeviceBtn.setImage(UIImage(named: "RemoveDevice"), forState: .Normal)
        removeDeviceBtn.frame = CGRectMake(tl, tl, lr, lr)
        removeDeviceBtn.addTarget(self, action: #selector(DevicesViewController.switchEditingMode), forControlEvents: .TouchUpInside)
        removeDeviceButton = UIBarButtonItem(customView: removeDeviceBtn)
        
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    func switchEditingMode()
    {
        if(tableView.editing)
        {
            tableView.setEditing(false, animated: true)
            (removeDeviceButton.customView as! UIButton).setImage(UIImage(named: "RemoveDevice"), forState: .Normal)
        }
        else
        {
            tableView.setEditing(true, animated: true)
            (removeDeviceButton.customView as! UIButton).setImage(UIImage(named: "RemoveDeviceDone"), forState: .Normal)
        }
    }
    
    func editItemSegue()
    {
        performSegueWithIdentifier("DeviceDetails", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if(context.devices.count==0)
        {
            return
        }

        for index in 0...context.devices.count-1
        {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! DeviceTableViewCell
            
            context.devices[index].state = cell.stateSwitch.on
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return context.devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "DeviceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeviceTableViewCell
        
        let device = context.devices[indexPath.row]
        
        cell.nameLabel.text = device.name
        cell.stateSwitch.hidden = false
        cell.stateSwitch.on = context.devices[indexPath.row].state
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            if(indexPath.row < context.devices.count)
            {
                context.devices.removeAtIndex(indexPath.row)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert { }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "DeviceDetails"
        {
            if (sender == nil)
            {
                let deviceViewController = segue.destinationViewController as! DeviceViewController
                deviceViewController.index = -1
                return
            }
            
            let deviceViewController = segue.destinationViewController as! DeviceViewController
            
            if let selectedDeviceCell = sender as? DeviceTableViewCell
            {
                let indexPath = tableView.indexPathForCell(selectedDeviceCell)!
                 deviceViewController.index = indexPath.row
            }
        }
    }
}
