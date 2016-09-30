//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Foundation

class ContextEntry: NSObject, NSCoding
{
    var name: String = ""
    var devices : [Device] = []
    
    init(name: String, devices : [Device])
    {
        self.name = name
        
        if(devices.count > 0)
        {
            for i in 0...devices.count - 1
            {
                let device = devices[i]
                self.devices.append(Device(name: device.name, topic: device.topic, color: device.color, state: device.state)!)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder)
    {
        if let name = aDecoder.decodeObjectForKey("name") as? String
        {
            self.name = name
        } else { self.name = "" }
        
        if let devices = aDecoder.decodeObjectForKey("devices") as? [Device]
        {
            self.devices = devices
        } else { self.devices = [] }
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(devices, forKey: "devices")
        aCoder.encodeObject(name, forKey: "name")
    }
    
    func save()
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "contextEntry")
    }
    
    func clear()
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("contextEntry")
    }
}
