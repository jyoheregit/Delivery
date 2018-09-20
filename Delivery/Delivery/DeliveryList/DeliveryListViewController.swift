//
//  DeliveryListViewController.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DeliveryListViewController : BaseCollectionViewController {
    
    var networkManager : NetworkManager?
    var coordinator : DeliveryListCoordinator?

    lazy var fetchedResultsController: NSFetchedResultsController<Delivery> = {
        let fetchedResultsController = CoreDataManager.shared.fetchedResultsController
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDeliveries()
    }
    
    //MARK: Custom Overrides
    
    override func registerCell() {
        collectionView.register(cell: DeliveryCell.self)
    }
    
    override func setupUI() {
        displayRefreshControl = true
        super.setupUI()
    }
    
    override func title() -> String? {
        return Constants.Title.deliveryList
    }
    
    override func setupDataSource() {
        let dataSource = DeliveryListDataSource(collectionView: collectionView,
                                                fetchedResultsController: fetchedResultsController)
        self.collectionViewDataSource = dataSource
    }
    
    override func setupDelegate() {
        let delegate = DeliveryListDelegate(collectionView: collectionView,
                                            fetchedResultsController: fetchedResultsController,
                                            coordinator: coordinator)
        self.collectionViewDelegate = delegate
        collectionView.delegate = self
    }
    
    override func refresh() {
        super.refresh()
        fetchDeliveries()
    }
}

//MARK: Fetch Logic

extension DeliveryListViewController {
    
    func fetchDeliveries() {
        
        showActivityIndicator()
        fetchFromDB()
        fetchFromNetwork()
    }
    
    func fetchFromDB() {
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error  {
            print("Error: \(error)")
        }
    }
    
    func fetchFromNetwork(){
        
        guard let networkManager = self.networkManager else { return }
        
        networkManager.fetchDeliveries() { (deliveries, error) in
            
            guard let deliveries = deliveries  else {
                self.cleanup()
                if (self.fetchedResultsController.fetchedObjects?.count == 0){
                    if let error = error {
                        let messageView = self.emptyMessageViewWith(message: error.localizedDescription)
                        self.collectionView.backgroundView = messageView
                    }
                }
                return
            }
            self.collectionView.backgroundView = nil
            CoreDataManager.shared.clearData()
            CoreDataManager.shared.insertInDB(deliveryModelList: deliveries)
            self.cleanup()
        }
    }
    
    func cleanup() {
        self.hideActivityIndicator()
        self.endRefreshing()
    }
}
