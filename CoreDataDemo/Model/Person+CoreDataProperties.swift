//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Josue Arambula on 10/22/20.
//  Copyright © 2020 Josue Arambula. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64
    @NSManaged public var gender: String?

}
