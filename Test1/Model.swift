//
//  Model.swift
//  Test1
//
//  Created by Shamil Mazitov on 07.03.2022.
//

import Foundation
import CoreText
import CloudKit
import UIKit
import CoreData

/*struct DataSource: Decodable {
    let data: Root
}

struct Root: Decodable {
    let results: [Result]
}

public class Result: NSManagedObject, Decodable {
     enum CodingKeys: String, CodingKey {
        case id
        case name
        case resultDescription = "description"
    }
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder .userInfo[.context] as? NSManagedObjectContext else { fatalError("Error with manged object context")}
        let entity = NSEntityDescription.entity(forEntityName: "Personalities", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(Int.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let resultDescription = try values.decode(String.self, forKey: .resultDescription)
    }
}
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}
extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}*/



struct Source: Decodable {
    let data: DataSource
    
}

struct DataSource: Decodable {
    let results: [Result]
    enum CodingKeys: String, CodingKey {
        case results
        
    }
    
    
}
   
    
struct Result: Decodable {
    var id: Int
    var name: String
    var resultDescription: String?
    var path: String?
    var directExtension: String?
    var urlString: String
    enum ResultCodingKeys : String, CodingKey {
        case id
        case name
        case resultDescription = "description"
        case thumbnail
        case path
        case directExtension = "extension"
        
    }


    
  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: ResultCodingKeys.self)
      self.id = try container.decode(Int.self, forKey: .id)
      self.name = try container.decode(String.self, forKey: .name)
      self.resultDescription = try container.decode(String.self, forKey: .resultDescription)
      let thumbContainer = try container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .thumbnail)
      self.path = try thumbContainer.decode(String.self, forKey: .path)
      self.directExtension = try thumbContainer.decode(String.self, forKey: .directExtension)
      self.urlString = String("\(path!)" + "." + "\(directExtension!)")
    }
    
}







/*extension DataSource {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var resultArray = try container.nestedUnkeyedContainer(forKey: .results)
        var results: [Result] = []
        while (!resultArray.isAtEnd) {
            let result = try resultArray.decode(Result.self)
            results.append(result)
        }
        self.init(results: results)
    }
}*/


    /*let data: DataClass



struct DataClass: Decodable {
    let results: [Result]
}


struct Result: Decodable {
    var id: Int?
    var name: String?
    var resultDescription: String?
    var modified: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case resultDescription = "description"
        case modified
    }
}
}*/
//        }
/*init (from decoder: Decoder) throws {
        
    let container = try decoder.container(keyedBy: DataClass.CodingKeys.self)
    let resultContainer = try container.nestedContainer(keyedBy:Results.ResultCodingKeys.self , forKey: .results)
    self.id = try? resultContainer.decode(Int.self, forKey: .id)
    self.name = try? resultContainer.decode( String.self, forKey: .name)
    self.desription = try? resultContainer.decode(String.self, forKey: .desription)
    self.modified = try? resultContainer.decode(Date.self, forKey: .modified)
    
    /* let idS = try? resultsContainer.decode([Results].self, forKey: .id)
    let modifiedS = try? resultsContainer.decode([Results].self, forKey: .modified)
    let desriptionS = try? resultsContainer.decode([Results].self, forKey: .desription)*/
    
        /*let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        let itemsContainer = try container.nestedContainer(keyedBy: ResultsCodingKeys.self, forKey: .items)*/
      /* self.id = try? container.decode(Int.self, forKey: .id)
        self.name = try? container.decode( String.self, forKey: .name)
        self.desription = try? container.decode(String.self, forKey: .description)
        self.modified = try? container.decode(Date.self, forKey: .modified)*/
        
    }
   
//}





        

    }*/

