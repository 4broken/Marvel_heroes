//
//  Personalities+CoreDataClass.swift
//  Test1
//
//  Created by Shamil Mazitov on 09.04.2022.
//
//

import Foundation
import CoreData

@objc(Personalities)
public class Personalities: NSManagedObject {
    
}/*, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
        } catch {
            print("error")
        }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Personalities", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int64.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            resultDescription = try values.decode(String.self, forKey: .resultDescription)
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case resultDescription = "resultDescription"
    }
}
extension  CodingUserInfoKey {
static let context = CodingUserInfoKey(rawValue: "context")
}
*/
