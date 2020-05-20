//
//  Geofence.swift
//  Allways
//
//  Created by Jairo Batista on 1/7/17.
//  Copyright © 2017 AllWays. All rights reserved.
//

import Foundation
import CoreLocation

class GeofenceManager {
    
    static let sharedInstance = GeofenceManager()
    private init() {}
    
    // Enable Geofencing for Stop
    func enable(stop: Stop) {
        CLGeocoder().geocodeAddressString(stop.geocodingAddress(), completionHandler: { (placemarks, error) in
            
            // Set up CoreDataManager
            let coreData = CoreDataManager.sharedInstance
            
            if error != nil {
                print(error ?? "ERROR: Stop Unable to Enable Geofencencing")
                coreData.disableGeofenceStatus(stop: stop)
            }
            
            
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                stop.latitude = (coordinate?.latitude)!
                stop.longitude = (coordinate?.longitude)!
                
                // Instantiate Location Manager
                let vc = StopsVC()
                
                // Convert Stop Data -> Region Type
                let stopRegion = self.region(stop: stop, coordinate: coordinate!)
                
                // Start Monitoring
                vc.locationManager.startMonitoring(for: stopRegion)
                coreData.enableGeofenceStatus(stop: stop)
            
            } else {
                print("ERROR FORWARD GEOCODING")
                coreData.disableGeofenceStatus(stop: stop)
            }
        })
    }
    
    // Register Region For Geofencing
    func region(stop: Stop, coordinate: CLLocationCoordinate2D) -> CLCircularRegion {
        // Set Up Area
        let region = CLCircularRegion(center: coordinate, radius: 500, identifier: stop.location!)
        // Determine When To Notify
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    // Deactivate Geofence //
    func stopMonitoringAllRegions() {
        let vc = StopsVC()
        
        for region in vc.locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == region.identifier else { continue }
            vc.locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    // Stop Monotoring Specific Region //
    func stopMonitoringSpecificRegion(region: CLRegion) {
        let vc = StopsVC()
        vc.locationManager.stopMonitoring(for: region)
    }
}
