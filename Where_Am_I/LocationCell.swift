//
//  locationCell.swift
//  Where_Am_I
//
//  Created by MacsSuck on 2020-11-18.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    var location : Location! {
        didSet {
            self.setCellValues(location: location)
        }
    }
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    
    func setCellValues(location:Location){
        self.addressLabel.text = location.address
        self.timeLabel.text = location.time?.string()
        self.locationLabel.text = location.locationString
    }
}
