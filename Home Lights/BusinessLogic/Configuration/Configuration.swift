//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import Foundation

@objc internal protocol Configuration
{
    var host: String { get set }
    var port: Int32 { get set }
    var baseURL: String { get }
}