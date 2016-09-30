//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Typhoon

class CoreComponents: TyphoonAssembly
{
    internal dynamic func persistency() -> AnyObject
    {
        return TyphoonDefinition.withClass(LocalStorage.self)
        {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

    internal dynamic func configuration() -> AnyObject
    {
        return TyphoonDefinition.withClass(AppConfiguration.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.persistency), with: self.persistency())
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    internal dynamic func context() -> AnyObject
    {
        return TyphoonDefinition.withClass(AppContext.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.client), with: self.client())
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    internal dynamic func client() -> AnyObject
    {
        return TyphoonDefinition.withClass(AppClient.self)
        {
            (definition) in
            definition.injectProperty(#selector(CoreComponents.configuration), with: self.configuration())
            definition.scope = TyphoonScope.Singleton
        }
    }
}