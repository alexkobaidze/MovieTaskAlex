//
//  CoreDataManager.swift
//  MovieTaskAlex
//
//  Created by Alex on 25.08.22.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private init() {}
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var coreDataContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieTaskAlex")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = coreDataContainer.viewContext
    
    // MARK: - Core Data Save
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
                
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        
        let entityName = String(describing: objectType)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
            
        } catch {
            print(error)
            return [T]()
        }
        
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
    
    
    
}
