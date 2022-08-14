//
//  Convert.swift
//  Test1
//
//  Created by Shamil Mazitov on 07.03.2022.
//

import Foundation
import CryptoKit
import CoreData
import UIKit
extension String {
    func md5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}
extension Date {
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
struct NetworkManager {
    var results : [Result]?
    var publicKey = "92e135263bd6c4c4d1ac1f2fa37de96a"
    let privateKey = "34612cb7cc774d382525d8d5ac0663a878ee8725"
    
     func getAllCharacters()  {
         let queue = DispatchQueue(label: "com.network", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
         queue.async {
        let timeStamp = String(Date.currentTimeStamp)
        let hash = (timeStamp + privateKey + publicKey).md5()
        var request = URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)")!)
        request.httpMethod = "GET"
         
         URLSession.shared.dataTask(with: request) { data, response, _ in
                guard let data = data else {return }
                let parsed = parseJSON(withData: data)
             if !parsed.isEmpty {
                 self.savePersonalities(parsed)
             }
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                }
       }.resume()
   }
     }
    
    func parseJSON(withData data: Data) -> [Result]{
      guard
        let result = try? JSONDecoder().decode(Source.self, from: data)
        else {
            return []
        }
        
        return result.data.results
    }
    
    var personalities = [NSManagedObject]()
    
    
     func savePersonalities(_ result: [Result]) {
         let backgroundContext = DataStoreManager.shared.persistentContainer.newBackgroundContext()
         backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
         backgroundContext.undoManager = nil
         for item in result {
            guard
                let imageURL = URL(string: item.urlString),
                let imageData = try? Data(contentsOf: imageURL),
                let entity = NSEntityDescription.entity(forEntityName: "Personalities", in: backgroundContext)
             else {
                 return
             }
             let personalitiesObject = NSManagedObject(entity: entity, insertInto: backgroundContext)
                personalitiesObject.setValue(item.id, forKey: "id")
                personalitiesObject.setValue(item.name, forKey: "name")
                personalitiesObject.setValue(item.resultDescription, forKey: "resultDescription")
                personalitiesObject.setValue(imageData, forKey: "image")
         }
                         DispatchQueue.main.async {
                            if backgroundContext.hasChanges {
                                try? backgroundContext.save()
                                
                            }
                        }
     }
        }
         
         
     

