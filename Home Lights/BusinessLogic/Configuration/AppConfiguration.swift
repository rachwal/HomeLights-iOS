//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import AVFoundation
import CoreData

public class AppConfiguration: NSObject, Configuration
{
    var persistency: Persistency!
    
    var host: String
    {
        get
        {
            return getSerializedValue("Host", attribute: "address", defaultValue: "Enter host address")
        }
        set(address)
        {
            removeSerializedValue("Host")
            setSerializedValue("Host", attribute: "address", value: address)
        }
    }
    
    var port: Int32
    {
        get
        {
            return getSerializedValue("Port", attribute: "number", defaultValue: 1883)
        }
        set(value)
        {
            removeSerializedValue("Port")
            setSerializedValue("Port", attribute: "number", value: value)
        }
    }
    
    var baseURL: String
    {
        get
        {
            return "http://\(host):\(port)"
        }
    }
   
    private func getSerializedValue<T>(entity: String, attribute: String, defaultValue: T) -> T
    {
        
        let values = persistency.getValues(entity)
        if values.count > 0
        {
            if defaultValue is String
            {
                if let field = values.last!.valueForKey(attribute) as? String
                {
                    return field as! T
                }
            }
            
            if defaultValue is Int
            {
                if let field = values.last!.valueForKey(attribute) as? NSNumber
                {
                    return field.integerValue as! T
                }
            }
            
            if defaultValue is Bool
            {
                if let field = values.last!.valueForKey(attribute) as? Bool
                {
                    return field as! T
                }
            }
        }
        return defaultValue
    }
    
    private func setSerializedValue<T>(entity: String, attribute: String, value: T)
    {
        if let managedContext = persistency.context
        {
            let entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: managedContext)
            let selected = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            if let stringValue = value as? String
            {
                selected.setValue(stringValue, forKey: attribute)
            }
            else if let intValue = value as? Int
            {
                selected.setValue(NSNumber(integer: intValue), forKey: attribute)
            }
            else if let boolValue = value as? Bool
            {
                selected.setValue(Bool(boolValue), forKey: attribute)
            }
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print("setSerializedValue::managedContext.save()")
            }
        }
    }
    
    private func removeSerializedValue(entity: String)
    {
        if let managedContext = persistency.context
        {
            let request = NSFetchRequest(entityName: entity)
            
            do
            {
                let results = try managedContext.executeFetchRequest(request)
                for i in 0..<results.count
                {
                    managedContext.deleteObject(results[i] as! NSManagedObject)
                }
            }
            catch
            {
                print("removeSerializedValue::executeFetchRequest()")
            }
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print("removeSerializedValue::managedContext.save()")
            }
        }
    }
}