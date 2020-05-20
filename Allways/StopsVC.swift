//
//  FirstViewController.swift
//  Allways
//
//  Created by Jairo Batista on 9/29/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit
import MapKit

class StopsVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets & Buttons
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var stopTypeLabel: UILabel!
    @IBOutlet weak var stopStatusLabel: UILabel!
    @IBOutlet weak var stopLocationLabel: UILabel!
    @IBOutlet weak var stopAddressOneLabel: UILabel!
    @IBOutlet weak var stopAddressTwoLabel: UILabel!
    @IBOutlet weak var stopWindowLabel: UILabel!
    @IBOutlet weak var stopMoreButton: UIButton!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // StopsList
    var stopsList = [Stop]()
    
    // Enroute Stop
    var enrouteStop: Stop!
    
    // Set Up Location Manager
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = false
        manager.pausesLocationUpdatesAutomatically = true
        return manager
    }()
    
    // Set Up Singletons
    let phoneInstance = PhoneManager.sharedInstance
    let intervalInstance = IntervalManager.sharedInstance
    let accountIDInstance = AccountIDManager.sharedInstance
    let serverIDInstance = ServerIDManager.sharedInstance
    let loadIDInstance = LoadIDManager.sharedInstance
    let coreData = CoreDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Determine Background Location Status
        self.determineBackgroundLocation()
        
        // Check If User Has Phone Number Saved
        if phoneInstance.get() != nil {
            // Check if User Authorized Tracking
            self.locationAuthorizationStatus()
        }
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch & Set Core Data
        stopsList = coreData.fetchAndSetStops()!
        if stopsList.count == 0 {
            configureNone()
        } else {
            configureEnrouteStop()
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Enroute More Button
    
    @IBAction func enrouteMoreButton(_ sender: AnyObject) {
        
        // Make Sure There's A Stop
        if enrouteStop != nil {
            let selectedStop = self.enrouteStop
            performSegue(withIdentifier: "StopDetailVC", sender: selectedStop)
        } else {
            // Send Request to Server
            let data = APICall(phone: self.phoneInstance.get()!)
            data.post()
        }
        
    }
    
    
    // MARK: - Table View Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "stopCell") as? StopTableViewCell {
            
            let stop = stopsList[indexPath.row]
            cell.configureCell(stop: stop)
            return cell
        } else {
            return StopTableViewCell()
        }
    }
    
    // Did Select Cell Function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Stop
        let selectedStop = stopsList[indexPath.row]
        
        // Perform Segue
        performSegue(withIdentifier: "StopDetailVC", sender: selectedStop)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Selected Cell
        if segue.identifier == "StopDetailVC" {
            if let detailsVC = segue.destination as? StopDetailVC {
                if let selectedStop = sender as? Stop {
                    detailsVC.stopInstance = selectedStop
                }
            }
        }
    }
}


// MARK: - Enroute Stop Configuration

extension StopsVC {
    
    func configureEnrouteStop() {
        self.enrouteStop = self.stopsList.removeFirst()
        self.stopTypeLabel.text = enrouteStop.typeInitial()
        self.stopLocationLabel.text = enrouteStop.location
        self.stopAddressOneLabel.text = enrouteStop.addressOne()
        self.stopAddressTwoLabel.text = enrouteStop.addressTwo()
        self.stopWindowLabel.text = enrouteStop.appointmentWindow()
        self.timeRemainingLabel.text = enrouteStop.timeRemaining()
        
        // Display Red Bold Text if Overdue
        if enrouteStop.timeRemaining() == "OVERDUE" {
            self.timeRemainingLabel.textColor = UIColor.red
            self.timeRemainingLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        }
    }
    
    func configureNone() {
        self.stopTypeLabel.text = ""
        self.stopLocationLabel.text = "No Stops Assigned"
        self.stopAddressOneLabel.text = "contact dispatcher"
        self.stopAddressTwoLabel.text = ""
        self.timeRemainingLabel.text = String(describing: Date())
        self.stopWindowLabel.text = ""
        self.stopMoreButton.setTitle("Request", for: UIControlState.normal)
    }
}
