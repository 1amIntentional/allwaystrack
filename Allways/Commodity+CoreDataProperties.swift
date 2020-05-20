//
//  Commodity+CoreDataProperties.swift
//  Allways
//
//  Created by Jairo Batista on 11/4/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import Foundation
import CoreData


extension Commodity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Commodity> {
        return NSFetchRequest<Commodity>(entityName: "Commodity");
    }

    @NSManaged public var itemDescription: String?
    @NSManaged public var item: String?
    @NSManaged public var weight: String?
    @NSManaged public var poIdentity: String?
    @NSManaged public var quantity: String?
    @NSManaged public var stop: Stop?

}
