//
//  StopDetailVC.swift
//  Allways
//
//  Created by Jairo Batista on 11/30/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit

class StopDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressOneLabel: UILabel!
    @IBOutlet weak var addressTwoLabel: UILabel!
    @IBOutlet weak var appWindowLabel: UILabel!
    @IBOutlet weak var stopTypeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var geofenceLabel: UILabel!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Commodity
    var commodityList = [Commodity]()
    
    // Instance
    let coreData = CoreDataManager.sharedInstance
    
    var stopInstance: Stop!
    
    override func viewDidLoad() {
        
        // View Configuration
        super.viewDidLoad()
        self.configureStop()
        self.title = stopInstance.location
        tableView.delegate = self
        tableView.dataSource = self
        
        // Core Data
        commodityList = coreData.fetchAndSetCommodities(stopID: stopInstance.objectID)!
        coreData.removeUnreadNoti(stop: stopInstance)
    }
    
    
    // MARK: - Table View Code
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commodityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commodityCell") as? CommodityTableViewCell {
            
            let commodity = commodityList[indexPath.row]
            cell.configureCell(commodity: commodity)
            return cell
        } else {
            return StopTableViewCell()
        }
    }
}


// MARK: - Stop Configuration

extension StopDetailVC {
    
    func configureStop() {
        self.addressOneLabel.text = stopInstance.addressOne()
        self.addressTwoLabel.text = stopInstance.addressTwo()
        self.appWindowLabel.text = stopInstance.appointmentWindow()
        self.stopTypeLabel.text = stopInstance.type
        self.timeLabel.text = stopInstance.timeRemaining()
        
        // Display Red Bold Text if Overdue
        if stopInstance.timeRemaining() == "OVERDUE" {
            self.timeLabel.textColor = UIColor.red
            self.timeLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        }
        
        // Geofence
        if stopInstance.geofenceActivated == false {
            self.geofenceLabel.isHidden = true
        } else {
            // Geofence Is Activated
        }
    }
}
