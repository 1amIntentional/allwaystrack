//
//  Stop+CoreDataProperties.swift
//  Allways
//
//  Created by Jairo Batista on 11/4/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation
import CoreData


extension Stop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stop> {
        return NSFetchRequest<Stop>(entityName: "Stop");
    }

    @NSManaged public var location: String?
    @NSManaged public var address: String?
    @NSManaged public var appointmentStart: NSDate?
    @NSManaged public var appointmentEnd: NSDate?
    @NSManaged public var arrive: Bool
    @NSManaged public var city: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var depart: Bool
    @NSManaged public var geofenceActivated: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var state: String?
    @NSManaged public var zip: String?
    @NSManaged public var unreadNotification: Bool
    @NSManaged public var type: String?
    @NSManaged public var stopID: Int16
    @NSManaged public var commodities: NSSet?

}

// MARK: Generated accessors for commodities
extension Stop {

    @objc(addCommoditiesObject:)
    @NSManaged public func addToCommodities(_ value: Commodity)

    @objc(removeCommoditiesObject:)
    @NSManaged public func removeFromCommodities(_ value: Commodity)

    @objc(addCommodities:)
    @NSManaged public func addToCommodities(_ values: NSSet)

    @objc(removeCommodities:)
    @NSManaged public func removeFromCommodities(_ values: NSSet)

}
