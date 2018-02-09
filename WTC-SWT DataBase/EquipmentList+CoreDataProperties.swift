//
//  EquipmentList+CoreDataProperties.swift
//  WTC-SWT DataBase
//
//  Created by mohammed al-batati on 1/5/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//
//

import Foundation
import CoreData


extension EquipmentList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EquipmentList> {
        return NSFetchRequest<EquipmentList>(entityName: "EquipmentList")
    }

    @NSManaged public var aquireCost: Double
    @NSManaged public var assetCode: String?
    @NSManaged public var bl: String?
    @NSManaged public var bu: String?
    @NSManaged public var details: String?
    @NSManaged public var image: NSData?
    @NSManaged public var location: String?
    @NSManaged public var nbv: Double
    @NSManaged public var po: Int16
    @NSManaged public var serialNumer: String?
    @NSManaged public var type: String?
    @NSManaged public var certificate: NSSet?

}

// MARK: Generated accessors for certificate
extension EquipmentList {

    @objc(addCertificateObject:)
    @NSManaged public func addToCertificate(_ value: Certification)

    @objc(removeCertificateObject:)
    @NSManaged public func removeFromCertificate(_ value: Certification)

    @objc(addCertificate:)
    @NSManaged public func addToCertificate(_ values: NSSet)

    @objc(removeCertificate:)
    @NSManaged public func removeFromCertificate(_ values: NSSet)

}
