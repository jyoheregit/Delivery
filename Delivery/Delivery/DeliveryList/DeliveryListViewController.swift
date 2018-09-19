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
    
    private var deliveries : [DeliveryModel]?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Custom Overrides
    
    override func registerCell() {
        collectionView.register(DeliveryCell.self, forCellWithReuseIdentifier: "DeliveryCell")
    }
    
    override func setupUI() {
        displayRefreshControl = true
        super.setupUI()
    }
    
    override func setupDataSource() {
        let dataSource = DeliveryListDataSource(collectionView: collectionView, fetchedResultsController: fetchedResultsController)
        self.collectionViewDataSource = dataSource
    }
    
    override func setupDelegate() {
        let delegate = DeliveryListDelegate(collectionView: collectionView, fetchedResultsController: fetchedResultsController,
                                            coordinator: coordinator)
        self.collectionViewDelegate = delegate
        collectionView.delegate = self
    }
    
    override func refresh() {
        super.refresh()
        fetchDeliveries()
    }
    
    //MARK: Fetch Deliveries
    
    func fetchDeliveries() {
        
        showActivityIndicator()
        do {
            try fetchedResultsController.performFetch()
        } catch let error  {
            print("Error: \(error)")
        }
        
        networkManager?.fetchDeliveries() { (deliveries, error) in
        
            guard let deliveries = deliveries  else {
                self.cleanup()
                if (self.fetchedResultsController.fetchedObjects?.count == 0){
                    if let error = error {
                        self.collectionView.backgroundView = self.emptyMessageViewWith(message: error.localizedDescription)
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



