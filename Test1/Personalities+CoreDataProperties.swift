//
//  Personalities+CoreDataProperties.swift
//  Test1
//
//  Created by Shamil Mazitov on 09.04.2022.
//
//

import Foundation
import CoreData


extension Personalities {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Personalities> {
        return NSFetchRequest<Personalities>(entityName: "Personalities")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var resultDescription: String?
    @NSManaged public var image: Data?

}

extension Personalities : Identifiable {

}
