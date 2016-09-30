//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Typhoon

class ApplicationAssembly: TyphoonAssembly
{
    var coreComponents: CoreComponents!

    dynamic func colorViewController() -> AnyObject
    {
        return TyphoonDefinition.withClass(ColorViewController.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.context), with: self.coreComponents.context())
            definition.injectProperty(#selector(CoreComponents.client), with: self.coreComponents.client())
        }
    }

    dynamic func contextsViewController() -> AnyObject
    {
        return TyphoonDefinition.withClass(ContextsViewController.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.client), with: self.coreComponents.client())
            definition.injectProperty(#selector(CoreComponents.context), with: self.coreComponents.context())
        }
    }
    
    dynamic func deviceViewController() -> AnyObject
    {
        return TyphoonDefinition.withClass(DeviceViewController.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.context), with: self.coreComponents.context())
        }
    }
    
    dynamic func devicesViewController() -> AnyObject
    {
        return TyphoonDefinition.withClass(DevicesViewController.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.context), with: self.coreComponents.context())
        }
    }
    
    dynamic func settingsViewController() -> AnyObject
    {
        return TyphoonDefinition.withClass(SettingsViewController.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.configuration), with: self.coreComponents.configuration())
            definition.injectProperty(#selector(CoreComponents.client), with: self.coreComponents.client())
        }
    }
}