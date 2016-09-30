//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Foundation
import UIKit

@objc internal protocol Context: NSCoding
{
    var entries : [ContextEntry] { get set }

    var name: String { get set }
    var devices : [Device] { get set }
    
    func add()
    
    func load(index: Int)
    func save(index: Int)
    
    func deserialize()
}

class AppContext: NSObject, Context
{
    var client: Client!
    
    var current: ContextEntry = ContextEntry(name: "Default", devices: [])
    
    var entries: [ContextEntry] = []
    
    var name: String
    {
        get
        {
            return current.name
        }
        set(value)
        {
            current.name = value
        }
    }
    
    var devices : [Device]
    {
        get
        {
            return current.devices
        }
        set(value)
        {
            current.devices = value
        }
    }
    
    override init() {
        super.init()
        
        self.name = ""
        self.devices = []
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {
        self.init()
        
        if let name = aDecoder.decodeObjectForKey("name") as? String
        {
            self.name = name
        }
        if let devices = aDecoder.decodeObjectForKey("devices") as? [Device]
        {
           self.devices = devices
        }
        if let entries = aDecoder.decodeObjectForKey("entries") as? [ContextEntry]
        {
            self.entries = entries
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(devices, forKey: "devices")
        aCoder.encodeObject(entries, forKey: "entries")
    }
    
    func clear()
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("appContext")
    }
    
    func deserialize()
    {
        if let appContextData = NSUserDefaults.standardUserDefaults().objectForKey("appContext") as? NSData
        {
            if let context = NSKeyedUnarchiver.unarchiveObjectWithData(appContextData) as? AppContext
            {
                self.name = context.name
                self.devices = context.devices
                self.entries = context.entries
            }
        }
    }
    
    func add()
    {
        entries.append(ContextEntry(name: "Context \(entries.count + 1)", devices: []))
    }
    
    func load(index: Int)
    {
        current.name = entries[index].name
        current.devices = [Device]()
        
        if(entries[index].devices.count == 0)
        {
            return
        }
        
        for i in 0...entries[index].devices.count-1
        {
            let device = entries[index].devices[i]
            current.devices.append(Device(name: device.name, topic: device.topic, color: device.color, state: device.state)!)
        }
    }
    
    func save(index: Int)
    {
        if current.devices.count > 0
        {
            entries[index].devices = [Device]()
        
            for i in 0...current.devices.count-1
            {
                let device = current.devices[i]
                entries[index].devices.append(Device(name: device.name, topic: device.topic, color: device.color, state: device.state)!)
            }
        }
        serialize()
    }
    
    private func serialize()
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "appContext")
    }
}