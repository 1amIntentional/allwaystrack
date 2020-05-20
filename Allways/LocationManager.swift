//
//  LocationManager.swift
//  Allways
//
//  Created by Jairo Batista on 11/30/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import CoreLocation


// MARK: - Location Manager Stack

extension StopsVC {
    
    // Check Location Tracking Authorization
    func locationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // Check If User Changes Authorization Status
    // TODO: Update location once, not continuesly
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    // Permit Background Location Updates When Interval Is > 0
    func determineBackgroundLocation() {
        if self.intervalInstance.get() > 0 {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            locationManager.allowsBackgroundLocationUpdates = false
        }
    }
}


// MARK: - APICall / LocationAPICall Stack

extension StopsVC {
    
    // Successful Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            
            // Send Default Request If Interval == 0
            if self.intervalInstance.get() == 0 {
                let data = APICall(phone: self.phoneInstance.get()!)
                data.post()
            } else {
                // Proceed w/ Reverse Geocoding
                CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                    // If Reverse Geocoding Fails
                    if (error != nil) {
                        print("ERROR: Reverse Geocoding Failed.")
                    } else {
                        let p = CLPlacemark(placemark: placemarks![0])
                        
                        // Reverse Geocoding Data
                        let country = p.isoCountryCode!
                        let state = p.administrativeArea!
                        let city = p.locality!
                        let zip = p.postalCode!
                        var street = String()
                        
                        // Street Information Tends To Be Unrealiable
                        if p.thoroughfare != nil {
                            street = p.thoroughfare!
                        } else {
                            street = "nil"
                        }
                        
                        // Create LocationAPICall Instance to Encapusulate Data
                        let data = LocationAPICall(phone: self.phoneInstance.get()!, lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude, head: userLocation.course, speed: userLocation.speed, street: street, city: city, zip: zip, state: state, country: country, accountID: self.accountIDInstance.get()!, serverID: self.serverIDInstance.get()!, loadID: self.loadIDInstance.get()!)
                        
                        // Send Data to Server
                        data.post()
                    }
                }
            }
        }
    }
    
    // Failing Location Updates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR finding location: \(error.localizedDescription)")
    }
    
    // Failing Geofence Monitoring
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("ERROR: Monitoring failed for region with identifier:\(region?.identifier)")
    }
}
