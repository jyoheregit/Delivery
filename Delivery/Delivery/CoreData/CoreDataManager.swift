//
//  CoreDataManager.swift
//  Delivery
//
//  Created by Joe on 16/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {
        setupNotifications()
    }
    
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
    
    var fetchedResultsController: NSFetchedResultsController<Delivery> {
        
        let fetchRequest: NSFetchRequest<Delivery> = Delivery.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func insertInDB(deliveryModelList : [DeliveryModel]) {
        
        for deliveryModel in deliveryModelList {
            
            guard let delivery = NSEntityDescription.insertNewObject(forEntityName: "Delivery", into: self.managedObjectContext()) as? Delivery else {
                return
            }
            delivery.id = deliveryModel.id!
            delivery.desc = deliveryModel.description
            delivery.imageUrl = deliveryModel.imageUrl
            
            guard let deliveryLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: self.managedObjectContext()) as? Location else {
                return
            }
            
            if let locationModel = deliveryModel.location {
                deliveryLocation.latitude = locationModel.latitude!
                deliveryLocation.longitude = locationModel.longitude!
                deliveryLocation.address = locationModel.address
                delivery.location = deliveryLocation
            }
            saveContext()
        }
    }
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(forName: Notification.Name.UIApplicationWillTerminate, object: nil, queue: OperationQueue.main) { _ in
            self.saveContext()
        }
        notificationCenter.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { _ in
            self.saveContext()
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
