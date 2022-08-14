//
//  DataStoreManager.swift
//  Test1
//
//  Created by Shamil Mazitov on 02.04.2022.
//

import Foundation
import CoreData

final class DataStoreManager {
    
    // MARK: - Properties
    
    public static let shared = DataStoreManager()
    
     lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Test1")
        container.loadPersistentStores(completionHandler: { _, _ in
            
        })
         container.viewContext.undoManager = nil
         container.viewContext.automaticallyMergesChangesFromParent = true
         container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()
    
    // MARK: - Initial methods
    
     init() {
        
    }
    
    // MARK: - Custom methods
    // MARK: Public methods
    
    public func getObjects<T: NSManagedObject>(withContext
                                               context: NSManagedObjectContext,
                                               predicate: NSPredicate? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        guard
            let entityName = request.entityName,
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else {
            return []
        }
        
        request.entity = entity
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            
            return result
        } catch {
            return []
        }
    }
    
    public func getObject<T: NSManagedObject>(withContext
                                              context: NSManagedObjectContext,
                                              predicate: NSPredicate? = nil) -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        guard
            let entityName = request.entityName,
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else {
            return nil
        }
        
        request.entity = entity
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            
            return result.first
        } catch {
            return nil
        }
    }
    
    public func saveContext (_ context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                    try? context.save()
                }
                    context.reset()
                }
            }
        

}
