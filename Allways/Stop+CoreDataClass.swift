//
//  Stop+CoreDataClass.swift
//  Allways
//
//  Created by Jairo Batista on 11/4/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation
import CoreData

@objc(Stop)
public class Stop: NSManagedObject {
    
    // Diplay Street
    func addressOne() -> String? {
        return self.address
    }
    
    // Display City, State, & Zip
    func addressTwo() -> String? {
        return "\(self.city!), \(self.state!), \(self.zip!)"
    }
    
    // Forward Geocoding Address
    func geocodingAddress() -> String {
        return "\(self.addressOne()), \(self.addressTwo())"
    }
    
    // Return Type as Initial -> Pickup (P) || Delivery (D)
    func typeInitial() -> String {
        if self.type?.lowercased() == "pickup" {
            return "P"
        } else if self.type?.lowercased() == "deliver" {
            return "D"
        } else {
            return self.type!
        }
    }
    
    // User Arrived / Departed ABBR
    func getStatus() -> String {
        if self.arrive == true && self.depart == false {
            return "A"
        } else if self.arrive == true && self.depart == true {
            return "D"
        } else {
            return "N/A"
        }
    }
    
    // User Arrived / Departed FULL
    func getFullStatus() -> String {
        if self.arrive == true && self.depart == false {
            return "ARRIVED"
        } else if self.arrive == true && self.depart == true {
            return "DEPARTED"
        } else {
            return "N/A"
        }
    }
    
    
    // Return Appointment Window
    func appointmentWindow() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let appointmentStartString = dateFormatter.string(from: self.appointmentStart! as Date)
        
        // If Appointment Start == End, Only Show One
        
        if self.appointmentStart == self.appointmentEnd {
            return appointmentStartString
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let appointmentEndString = dateFormatter.string(from: self.appointmentEnd! as Date)
            return appointmentStartString + "-" + appointmentEndString
        }
    }
    
    // Return Time Remaining/Elapsed
    func timeRemaining() -> String {
        if Int((self.appointmentEnd?.timeIntervalSinceNow)!) >= 0 {
            let timeIntervalOpt = self.appointmentEnd?.timeIntervalSinceNow
            if let timeInterval = timeIntervalOpt {
                let time = NSInteger(timeInterval)
                let minutes = (time / 60) % 60
                let hours = (time / 3600)
                return NSString(format: "%0.2d:%0.2d hours left",hours,minutes) as String
            } else {
                return "N/A"
            }
        } else {
            return "OVERDUE"
        }
    }
}
