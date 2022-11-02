//
//  Log+CoreDataProperties.swift
//  
//
//  Created by Hanz Christian on 02/11/22.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var action: String?
    @NSManaged public var bg_check_result: String?
    @NSManaged public var date: Date?
    @NSManaged public var dateTake: Date?
    @NSManaged public var log_id: String?
    @NSManaged public var medicine_name: String?
    @NSManaged public var time: String?
    @NSManaged public var type: Int16

}
