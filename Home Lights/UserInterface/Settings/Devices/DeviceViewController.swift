//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit

class DeviceViewController:  UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate
{
    var context: Context!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var topicTextField: UITextField!
    
    var device: Device?
    var index: Int?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        topicTextField.delegate = self
        
        if(index < 0 || context.devices.count == 0)
        {
            index = context.devices.count
            
            let newDevice = Device(name: "Device \(context.devices.count + 1)", topic: "/light/", color: UIColor.blackColor(), state: true)
            
            context.devices.append(newDevice!)
            device = context.devices.last
        }
        else
        {
            device = context.devices[index!]
        }
        
        if let device = device
        {
            navigationItem.title = device.name
            
            nameTextField.text   = device.name
            topicTextField.text = device.topic
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        navigationItem.title = textField.text
        
        context.devices[index!].name = nameTextField.text!
        context.devices[index!].topic = topicTextField.text!
    }
}

