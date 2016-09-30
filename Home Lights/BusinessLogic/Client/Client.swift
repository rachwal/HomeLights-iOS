//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Foundation
import Moscapsule

@objc internal protocol Client
{
    var isConnected: Bool { get }
    
    func connect();
    func disconnect();
    func update()
    
    func publishColor(color: UIColor, topic: String, callback: (Bool) -> Void)
}

class AppClient: NSObject, Client
{
    var configuration: Configuration!
    
    var mqttConfig: MQTTConfig?
    var mqttClient: MQTTClient?
    var uuid: String
    
    override init()
    {
        uuid = NSUUID().UUIDString
        super.init()
    }
    
    var isConnected: Bool
    {
        get
        {
            if(mqttClient == nil)
            {
                return false;
            }
            return mqttClient!.isConnected
        }
    }
    
    func publishColor(color: UIColor, topic: String, callback: (Bool) -> Void)
    {
        if(mqttClient == nil)
        {
            initialize()
        }
        
        if(isConnected)
        {
            mqttClient!.publishString(colorToHexString(color), topic: topic, qos: 1, retain: true)
        }
        
        callback(isConnected)
    }
    
    func update()
    {
        mqttClient?.disconnect()
        
        initialize()
    }
    
    func connect()
    {
        if(mqttClient == nil)
        {
            initialize()
        }
        
        mqttClient!.connectToHost(self.mqttConfig!.host, port: self.mqttConfig!.port, keepAlive: self.mqttConfig!.keepAlive)
    }
    
    func disconnect()
    {
        mqttClient?.disconnect()
    }
    
    private func initialize()
    {
        mqttConfig = MQTTConfig(clientId: uuid, host: configuration.host, port:configuration.port, keepAlive: 60)
        
        mqttConfig?.onPublishCallback = { messageId in }
        mqttConfig?.onMessageCallback = { mqttMessage in }
        
        mqttClient = MQTT.newConnection(mqttConfig!, connectImmediately: false)
    }
    
    private func colorToHexString(color:UIColor) -> String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
       
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"%06x", rgb) as String
    }
}
