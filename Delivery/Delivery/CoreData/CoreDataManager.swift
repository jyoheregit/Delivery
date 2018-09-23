//
//  CoreDataManager.swift
//  Delivery
//
//  Created by Joe on 16/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Delivery")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return persistentContainer
    }()
    
    var fetchedResultsController: NSFetchedResultsController<Delivery>{
        
        let fetchRequest: NSFetchRequest<Delivery> = Delivery.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func insertInDB(deliveryModelList : [DeliveryModel]) {
        
        for deliveryModel in deliveryModelList {
            
            guard let delivery = NSEntityDescription.insertNewObject(forEntityName: "Delivery",
                                                                     into: self.managedObjectContext()) as? Delivery else {
                return
            }
            if let id = deliveryModel.id { delivery.id = id }
            delivery.desc = deliveryModel.description
            delivery.imageUrl = deliveryModel.imageUrl
            
            guard let deliveryLocation = NSEntityDescription.insertNewObject(forEntityName: "Location",
                                                                             into: self.managedObjectContext()) as? Location else {
                return
            }
            
            if let locationModel = deliveryModel.location {
                
                if let latitude = locationModel.latitude {deliveryLocation.latitude = latitude}
                if let longitude = locationModel.longitude {deliveryLocation.longitude = longitude}
                
                deliveryLocation.address = locationModel.address
                delivery.location = deliveryLocation
            }
            saveContext()
        }
    }
    
    func clearData() {
        
        let context = managedObjectContext()
        let fetchRequest: NSFetchRequest<Delivery> = Delivery.fetchRequest()
        do {
            let deliveries  = try context.fetch(fetchRequest)
            deliveries.forEach{context.delete($0)}
            saveContext()
        } catch let error {
            print("Error Deleting : \(error)")
        }
    }
    
    func saveContext() {
    
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
