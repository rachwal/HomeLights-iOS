//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit

class Device: NSObject, NSCoding
{
    var name: String
    var topic: String
    var color: UIColor
    var state: Bool
  
    init?(name: String, topic: String, color: UIColor, state: Bool)
    {
        self.name = name
        self.topic = topic
        self.state = state
        self.color = color
    }
    
    required init(coder aDecoder: NSCoder)
    {
        if let name = aDecoder.decodeObjectForKey("name") as? String
        {
            self.name = name
        } else { self.name = "" }
        if let topic = aDecoder.decodeObjectForKey("topic") as? String
        {
            self.topic = topic
        } else { self.topic = "" }
        if let color = aDecoder.decodeObjectForKey("color") as? UIColor
        {
            self.color = color
        } else { self.color = UIColor.blackColor() }
        if let state = aDecoder.decodeObjectForKey("state") as? Bool
        {
            self.state = state
        } else { self.state = false }
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(topic, forKey: "topic")
        aCoder.encodeObject(color, forKey: "color")
        aCoder.encodeObject(state, forKey: "state")
    }
    
    func save()
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "newDevice")
    }
    
    func clear()
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("newDevice")
    }
}