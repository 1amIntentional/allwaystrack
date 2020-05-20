//
//  Middleware.swift
//  Allways
//
//  Created by Jairo Batista on 10/20/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Context
/*
 The reason behind why I decided to make the middleware a singleton are as follows
 1) B/c the object needs to control concurrent access to a shared resource.
 2) Access to the resouce will be requested from multiple seperate parts of the system (Messages, Geofence triggers, Location updates, ect)
 
 Middleware handles communication between AllWays server and application.
 Objects include:
 interval, loadID, Stop, Commodity, workOrder, serverID, accountID
 
*/

class MiddlewareManager {
    
    static let sharedInstance = MiddlewareManager()
    private init() {}
    
    // Determine MODE
    func parseAPIResponse(json: JSON) {
        
        // MODE: Create
        if (json["create"].dictionary != nil) {
            
            // Create New JSON From Nested Objects
            let createData = json["create"].dictionary
            let createJSON = JSON(createData!)
            
            // Call Appropriate Method According to Mode
            self.createMode(createJSON: createJSON)
            
        // MODE: Read
        } else if (json["read"].dictionary != nil) {
            let readData = json["read"].dictionary
            let readJSON = JSON(readData!)
            self.readMode(readJSON: readJSON)
            
        // MODE: Update
        } else if (json["update"].dictionary != nil) {
            let updateData = json["update"].dictionary
            let updateJSON = JSON(updateData!)
            self.updateMode(updateJSON: updateJSON)
        } else {
            // RESPONSE ERROR: CANNOT IDENTIFY MODE
            print("ERROR: Cannot determine mode from server response.")
        }
    }
    
    func createMode(createJSON: JSON) {
        // TODO: Notify User Of New Assignment
        // TODO: Check For An Incoming Message
        
        // Handle Interval, ServerID, AccountID, LoadID, WorkOrder
        self.updateDefaults(json: createJSON)
        
        // Handle Trip Data
        self.captureTripData(apiResponse: createJSON, isUpdate: false)
    }
    
    func readMode(readJSON: JSON) {
        // TODO: Check For An Incoming Message
        
        // Handle Interval, ServerID, AccountID, LoadID, WorkOrder
        self.updateDefaults(json: readJSON)
    }
    
    func updateMode(updateJSON: JSON) {
        // TODO: Notify User Of Assignment Update
        // TODO: Capture Stops & Commodities
        // TODO: Check For An Incoming Message
        
        // Handle Interval, ServerID, AccountID, LoadID, WorkOrder
        self.updateDefaults(json: updateJSON)
        
        // Handle Trip Data
        self.captureTripData(apiResponse: updateJSON, isUpdate: true)
    }
}


// MARK: - Capture Stops & Commodities, Determine Procedures Based on MODE, & Call Core Data Methods for Saving

extension MiddlewareManager {
    
    // Capture & Call Method to Save Stops & Commodities
    func captureTripData(apiResponse: JSON, isUpdate: Bool) {
        
        // Set up Core Data
        let coreData = CoreDataManager.sharedInstance
        
        // Check if there's Stop(s)
        if let stopsResponse = apiResponse["stops"].array {
            
            // Delete only Unarrived Stops
            if isUpdate == true {
                coreData.deleteUnarrivedStops()

            // Create MODE thus Delete All Previous Stops
            } else if isUpdate == false {
                coreData.deleteAllStops()
                
                // Remove All Geofences
                let geofenceManager = GeofenceManager.sharedInstance
                geofenceManager.stopMonitoringAllRegions()
            }
            
            // Only Publish Stops w/ Future Appointment End Dates
            for stop in stopsResponse {
                
                /*
                // Grab Appointment Close Time
                let stopDate = stop["to"].stringValue
                
                // Desired Date Format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                // Convert String Type -> Date Type
                let appointmentDate = dateFormatter.date(from: stopDate)!
                
                // Only Create Stop if it's In Future
                if appointmentDate.timeIntervalSinceNow >= 0 {
                    // Create Stop & Commodity
                    coreData.createStop(stopJSON: stop)
                } else {
                    print("In the past! \(appointmentDate)")
                }
                */
                coreData.createStop(stopJSON: stop)
            }
        } else {
            print("ERROR: No assigned stops in CREATE MODE.")
        }
    }
}


// MARK: - Handle Singletons Stack

extension MiddlewareManager {
    
    func updateDefaults(json: JSON) {
        // Interval: Capture, Update, & Save
        if (json["interval"].string) != nil {
            let interval = IntervalManager.sharedInstance
            let serverInterval = json["interval"].intValue
            interval.set(interval: serverInterval)
            interval.save()
        }
        
        // ServerID: Capture, Update, & Save
        if (json["server_id"].string) != nil {
            let serverID = ServerIDManager.sharedInstance
            let updatedID = json["server_id"].stringValue
            serverID.set(serverID: updatedID)
            serverID.save()
        }
        
        // LoadID: Capture, Update, & Save
        if (json["load_id"].string) != nil {
            let loadID = LoadIDManager.sharedInstance
            let updatedID = json["load_id"].stringValue
            loadID.set(loadID: updatedID)
            loadID.save()
        }
        
        // WorkOrder: Capture, Update, & Save
        if (json["wo"].string) != nil {
            let workOrder = WorkOrderManager.sharedInstance
            let id = json["wo"].stringValue
            workOrder.set(wo: id)
            workOrder.save()
        }
        
        // AccountID: Capture, Update & Save
        if (json["account_id"].string) != nil {
            let accountID = AccountIDManager.sharedInstance
            let id = json["account_id"].stringValue
            accountID.set(accountID: id)
            accountID.save()
        }
        
    }
}
