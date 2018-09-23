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
    
    var networkManager : Fetchable?
    var coordinator : DeliveryListCoordinator?

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
        isPaginationRequired = true
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
        offset = 0
        fetchDeliveries()
    }

    override func fetchMoreData() {
        
        offset += numberOfItemsToFetch
        guard let networkManager = self.networkManager else { return }
        
        networkManager.fetchDeliveries(offset : offset, limit: numberOfItemsToFetch) { [weak self] (deliveries, error) in
            
            guard let deliveries = deliveries  else {
                self?.resetOffset()
                return
            }
            
            if deliveries.count == 0 || error != nil {
                self?.resetOffset()
                return
            }
            
            CoreDataManager.shared.insertInDB(deliveryModelList: deliveries)
            self?.fetchingMoreData = false
        }
    }
    
    func resetOffset() {
        self.fetchingMoreData = false
        self.offset = self.offset > 0 ? self.offset - numberOfItemsToFetch : self.offset
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
        
        networkManager.fetchDeliveries(offset : offset, limit: numberOfItemsToFetch) {[weak self]  (deliveries, error) in
            
            guard let deliveries = deliveries else {
                if let isEmpty = self?.isDataEmpty(), isEmpty {
                    if let error = error {
                        self?.setErrorMessage(with: error)
                    }
                }
                self?.stopActivityIndicator()
                return
            }
            self?.collectionView.backgroundView = nil
            CoreDataManager.shared.clearData()
            CoreDataManager.shared.insertInDB(deliveryModelList: deliveries)
            self?.stopActivityIndicator()
        }
    }
    
    func isDataEmpty() -> Bool {
        
        guard let items = self.fetchedResultsController.fetchedObjects, items.count == 0 else { return false }
        return true
    }
    
    func setErrorMessage(with error : ErrorType){
        let messageView = self.emptyMessageViewWith(message: error.associatedValue() as? String)
        self.collectionView.backgroundView = messageView
    }
    
    func stopActivityIndicator() {
        self.hideActivityIndicator()
        self.endRefreshing()
    }
}
