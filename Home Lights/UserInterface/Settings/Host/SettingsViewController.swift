//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit
import AVFoundation

class SettingsViewController: UITableViewController, UITextFieldDelegate
{
    var configuration: Configuration!
    var client: Client!
    
    @IBOutlet weak var hostField: UITextField!
    @IBOutlet weak var portField: UITextField!

    @IBOutlet var connectedSwitch: UISwitch!
    
    @IBAction func connectedChange(sender: UISwitch)
    {
        if (sender.on)
        {
                self.client.connect()
        }
        else
        {
            client.disconnect()
        }
    }
    
    override func viewDidLoad()
    {
        navigationItem.title = "Settings"
      
        hostField.delegate = self
        portField.delegate = self
    }

    override func viewWillAppear(animated: Bool)
    {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.toolbarHidden = false
        
        self.setToolbarItems([], animated: true)
      
        initFields()
    }

    func initFields()
    {
        hostField.text = configuration.host
        portField.text = "\(configuration.port)"
        
        connectedSwitch.on = client.isConnected
    }

    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func displayNoConnectionPopup()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            let popup: UIAlertController = UIAlertController(title: "No Connection", message: "Please check WiFi status, host address and port settings.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            popup.addAction(action)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }

    @IBAction func hostAddressChanged(sender: UITextField)
    {
        configuration.host = sender.text!
        
        client.update()
    }

    @IBAction func portNumberChanged(sender: UITextField)
    {
        var correctValue = false
        
        if let newPort = Int32(sender.text!)
        {
            if newPort > 0 && newPort < 65536
            {
                correctValue = true
                configuration.port = newPort
                client.update()
            }
        }
        
        if !correctValue
        {
            dispatch_async(dispatch_get_main_queue())
            {
                let popup: UIAlertController = UIAlertController(title: "Incorrect value", message: "Port value should be an integer greater than than zero up to a value of 65535", preferredStyle: UIAlertControllerStyle.Alert)
                
                let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                popup.addAction(action)
                
                self.presentViewController(popup, animated: true)
                {
                    self.portField.text = "\(self.configuration.port)"
                }
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.endEditing(false)
        return true
    }
}
