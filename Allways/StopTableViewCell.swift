//
//  StopTableViewCell.swift
//  Allways
//
//  Created by Jairo Batista on 11/16/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit

class StopTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressOneLabel: UILabel!
    @IBOutlet weak var addressTwoLabel: UILabel!
    @IBOutlet weak var unreadNotificationImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var windowDataLabel: UILabel!
    
    func configureCell(stop: Stop) {
        locationLabel.text = stop.location
        addressOneLabel.text = stop.addressOne()
        addressTwoLabel.text = stop.addressTwo()
        typeLabel.text = stop.typeInitial()
        windowDataLabel.text = stop.appointmentWindow()
        // TODO: - UnreadNotification
        
        // Unread Notification Image
        if stop.unreadNotification == true {
            unreadNotificationImage.image = UIImage(named: "unreadIcon")
        } else {
            // do not put unreadIcon
            unreadNotificationImage.image = nil
        }
    }
}
