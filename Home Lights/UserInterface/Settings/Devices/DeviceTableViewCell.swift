//  Copyright (c) 2015-2016. Bartosz Rachwal. The National Institute of Advanced Industrial Science and Technology, Japan. All rights reserved.

import UIKit

class DeviceTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var stateSwitch: UISwitch!
    
    @IBAction func stateChanged(sender: UISwitch) { }
}