//
//  CoreData.swift
//  Allways
//
//  Created by Jairo Batista on 11/4/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import CoreData
import SwiftyJSON

/*
 CoreDataManager class handles all activities relating to Core Data Entities
 Create, Update, & Delete Methods
*/

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    private init() {}
    
    // Errors
    enum CoreDataError: Error {
        case noValue
    }
    
    
    // MARK: - Stop Stack
    
    func updateStopStatus(stop: Stop) {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        if stop.arrive == false && stop.depart == false {
            stop.arrive = true
        } else if stop.arrive == true && stop.depart == false {
            stop.depart = true
        }
        app.saveContext()
    }
    
    func disableGeofenceStatus(stop: Stop) {
        if stop.geofenceActivated == false {
            // Do nothing
        } else {
            let app = UIApplication.shared.delegate as! AppDelegate
            stop.geofenceActivated = false
            app.saveContext()
        }
    }
    
    func enableGeofenceStatus(stop: Stop) {
        if stop.geofenceActivated == true {
            // Do nothing
        } else {
            let app = UIApplication.shared.delegate as! AppDelegate
            stop.geofenceActivated = true
            app.saveContext()
        }
    }
    
    func removeUnreadNoti(stop: Stop) {
        if stop.unreadNotification == true {
            let app = UIApplication.shared.delegate as! AppDelegate
            stop.unreadNotification = false
            app.saveContext()
        } else {
            // Do nothing
        }
    }
    
    func createStop(stopJSON: JSON) {
        
        // Set Up Geofence Enabler
        let geofenceManager = GeofenceManager.sharedInstance
        
        // Set Up Core Data
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let stop = Stop(context: context)
        
        
        // MARK: - Date Stack
        
        // Capture String Value
        let appointmentEndString = stopJSON["to"].stringValue
        let appointmentStartString = stopJSON["from"].stringValue
        
        // Format Func
        func formatDate(appointmentString: String) -> Date? {
            // Set Up Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            // Convert Date String Type to Date Type
            return dateFormatter.date(from: appointmentString)
        }
        
        // Format & Set Start Attribute
        if let appointmentStartNSDate = formatDate(appointmentString: appointmentStartString) {
            stop.appointmentStart = appointmentStartNSDate as NSDate?
        }
        
        // Format & Set End Attribute
        if let appointmentEndNSDate = formatDate(appointmentString: appointmentEndString) {
            stop.appointmentEnd = appointmentEndNSDate as NSDate?
        }
        
        
        // Set Attributes
        stop.stopID = Int16(stopJSON["stop_id"].stringValue)!
        stop.location = stopJSON["location"].stringValue
        stop.city = stopJSON["city"].stringValue
        stop.address = stopJSON["address"].stringValue
        stop.state = stopJSON["state"].stringValue
        stop.zip = stopJSON["zip"].stringValue
        stop.type = stopJSON["type"].stringValue
        stop.arrive = false
        stop.depart = false
        stop.date = NSDate()
        stop.unreadNotification = true
        
        
        // MARK: - Commodities Stack
        
        if let commoditiesList = stopJSON["commodity"].array {
            
            for instance in commoditiesList {
                
                // Set Up Core Data
                let commodity = Commodity(context: context)
                
                // Set Attributes
                commodity.item = instance["item"].stringValue
                commodity .itemDescription = instance["description"].stringValue
                commodity.poIdentity = instance["poNumber"].stringValue
                commodity.quantity = instance["qty"].stringValue
                commodity.weight = instance["weight"].stringValue
                
                // Create Relationship //
                stop.mutableSetValue(forKey: "commodities").add(commodity)
                // Insert -> Context
                context.insert(commodity)
            }
        } else {
            // DO NOTHING
        }
        
        // Enable Geofence
        geofenceManager.enable(stop: stop)
        
        // Insert stop -> Context
        context.insert(stop)
        print(stop)
        
        // SAVE FROM CONTEXT TO CORE DATA
        do {
            try context.save()
        } catch {
            print("Could not save stop")
        }
    }
    
    // Utlized in Update MODE, In Order To Preserve Stops w/ Load Progress
    func deleteUnarrivedStops() {
        
        // Set Up Core Data
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        // SET UP PREDICATE FOR VALUE ARRIVE == FALSE
        let predicate = NSPredicate(format: "arrive == %@", 0)
        
        // MAKE FETCH REQUEST
        let request: NSFetchRequest<NSFetchRequestResult> = Stop.fetchRequest()
        request.predicate = predicate
        
        // Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        batchDeleteRequest.resultType = .resultTypeCount
        
        do {
            // Execute Batch Request
            let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
            print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
            
            // Reset Managed Object Context
            context.reset()
        } catch {
            let updateError = error as NSError
            print("CORE DATA: \(updateError), \(updateError.userInfo)")
        }
    }

    // Delete All Stops & Associated Commodities
    func deleteAllStops() {
        
        // Set Up Core Data
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        // MAKE FETCH REQUEST
        let request: NSFetchRequest<NSFetchRequestResult> = Stop.fetchRequest()
        
        // Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        batchDeleteRequest.resultType = .resultTypeCount
        
        do {
            // Execute Batch Request
            let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
            print("The batch delete request has all Stops & Commodities. \(batchDeleteResult.result!) records.")
            
            // Reset Managed Object Context
            context.reset()
        } catch {
            let updateError = error as NSError
            print("CORE DATA: \(updateError), \(updateError.userInfo)")
        }
    }
    
    
    // MARK: - Fetch Stack
    
    // Fetch and Set Stops for StopsVC TableView
    func fetchAndSetStops() -> Array<Stop>? {
        // Set Up Core Data
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        // MAKE FETCH REQUEST
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Stop.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results as? [Stop]
        } catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    // Fetch and Set Commodites for StopDetail Table View
    func fetchAndSetCommodities(stopID: NSManagedObjectID) -> Array<Commodity>? {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Commodity.fetchRequest()
        
        // PREDICATE OPTIONS
        let idAttribute = "stop"
        fetchRequest.predicate = NSPredicate(format: "%K == %@", idAttribute, stopID)
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            return results as? [Commodity]
        } catch let err as NSError {
            print(err.debugDescription)
            return nil
        }

    }
    
    func fetchStop(identifier: String) -> Stop? {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stop")
        
        // PREDICATE OPTIONS
        let idAttribute = "location"
        fetchRequest.predicate = NSPredicate(format: "%K == %@", idAttribute, identifier)
        
        do {
            let results = try context.fetch(fetchRequest)
            let convertedResults = results as! [Stop]
            return convertedResults.first!
            
            // TODO: Error handle if list generates more than one location
            
        } catch let err as NSError {
            print("ERROR \(err.debugDescription)")
            return nil
        }
    }
}
