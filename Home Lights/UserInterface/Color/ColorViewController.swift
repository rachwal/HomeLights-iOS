//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit
import AVFoundation
import AssetsLibrary

class ColorViewController: UIViewController
{
    var context: Context!
    var client: Client!
    
    var selectedColor: UIColor = UIColor.whiteColor()
    
    var contextButton: UIBarButtonItem!
    var devicesButton: UIBarButtonItem!
    var settingsButton: UIBarButtonItem!
    var flexibleSpace: UIBarButtonItem!
    
    var initialized: Bool = false
    
    @IBOutlet var colorPicker: SwiftHSVColorPicker!
    
    func initButtons()
    {
        let lr = (navigationController?.toolbar.frame.height)!*0.8
        let tl = (navigationController?.toolbar.frame.height)!-lr
        
        let contextBtn = UIButton()
        contextBtn.setImage(UIImage(named: "Contexts"), forState: .Normal)
        contextBtn.frame = CGRectMake(tl, tl, lr, lr)
        contextBtn.addTarget(self, action: #selector(ColorViewController.contextSegue), forControlEvents: .TouchUpInside)
        contextButton = UIBarButtonItem(customView: contextBtn)
        
        let devicesBtn = UIButton()
        devicesBtn.setImage(UIImage(named: "Devices"), forState: .Normal)
        devicesBtn.frame = CGRectMake(tl, tl, lr, lr)
        devicesBtn.addTarget(self, action: #selector(ColorViewController.devicesSegue), forControlEvents: .TouchUpInside)
        devicesButton = UIBarButtonItem(customView: devicesBtn)
        
        let settingsBtn = UIButton()
        settingsBtn.setImage(UIImage(named: "Settings"), forState: .Normal)
        settingsBtn.frame = CGRectMake(tl, tl, lr, lr)
        settingsBtn.addTarget(self, action: #selector(ColorViewController.settingsSegue), forControlEvents: .TouchUpInside)
        settingsButton = UIBarButtonItem(customView: settingsBtn)
        
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    }
    
    func contextSegue()
    {
        performSegueWithIdentifier("ShowContexts", sender: nil)
    }
    
    func devicesSegue()
    {
        performSegueWithIdentifier("ShowDevices", sender: nil)
    }
    
    func settingsSegue()
    {
        performSegueWithIdentifier("ShowSettings", sender: nil)
    }
    
    override func viewDidLoad()
    {
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.toolbar.barStyle = .Black
        navigationController?.toolbar.backgroundColor = UIColor.blackColor()
        navigationController?.toolbarHidden = false
        
        initButtons()
        
        context.deserialize()
        
        self.setToolbarItems([contextButton, flexibleSpace, devicesButton, flexibleSpace, settingsButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        colorPicker.setColorChangedCallback({
            self.selectedColor = self.colorPicker.color
            
            for device in self.context.devices
            {
                if device.state
                {
                    device.color = self.colorPicker.color
                    self.client.publishColor(self.colorPicker.color, topic: device.topic, callback: self.checkStatus)
                }
            }
        })
    }
    
    func checkStatus(status: Bool)
    {
        if(status)
        {
            return
        }
        
        dispatch_async(dispatch_get_main_queue())
        {
            let popup: UIAlertController = UIAlertController(title: "No Connection", message: "Please check WiFi status, host address and port settings.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "Connect", style: UIAlertActionStyle.Default, handler:
            {
                    (alert: UIAlertAction!) in
                    
                    let connecting: UIAlertController = UIAlertController(title: "Connecting", message: "Please wait ...", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    self.presentViewController(connecting, animated: true, completion: {
                        
                        self.client.connect()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
            });
            
            let skip: UIAlertAction = UIAlertAction(title: "Skip", style: UIAlertActionStyle.Cancel, handler: nil);
            
            popup.addAction(action)
            popup.addAction(skip)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if !initialized {
            colorPicker.setViewColor(selectedColor)
            initialized = true
        }
    }
}
