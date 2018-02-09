//
//  Certification+CoreDataProperties.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/5/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//
//

import Foundation
import CoreData


extension Certification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Certification> {
        return NSFetchRequest<Certification>(entityName: "Certification")
    }

    @NSManaged public var certificatedate: NSDate?
    @NSManaged public var certificateexpiry: NSDate?
    @NSManaged public var certificatefile: NSData?
    @NSManaged public var certificatenotes: String?
    @NSManaged public var certificatetype: String?
    @NSManaged public var id: UUID?
    @NSManaged public var equipment: EquipmentList?

}
