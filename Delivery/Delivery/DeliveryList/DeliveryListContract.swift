//
//  DeliveryListDataSource.swift
//  Delivery
//
//  Created by Joe on 17/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import CoreData

class DeliveryListDataSource : CollectionViewDataSource {
    
    weak var collectionView: UICollectionView?
    var fetchedResultsController : NSFetchedResultsController<Delivery>
    
    init(collectionView : UICollectionView, fetchedResultsController : NSFetchedResultsController<Delivery>) {
        self.collectionView = collectionView
        self.fetchedResultsController = fetchedResultsController
    }
    
    func numberOfItemsInSection() -> Int {
        
        guard let count = fetchedResultsController.sections?.first?.numberOfObjects else {
            return 0
        }
        return count
    }
    
    func cellForItemAtIndexPath(indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionView = self.collectionView else { fatalError("Collection view is nil") }
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DeliveryCell
        let delivery = fetchedResultsController.object(at: indexPath)
        cell.delivery = delivery
        return cell
    }
}

class DeliveryListDelegate : CollectionViewDelegate {
    
    weak var collectionView: UICollectionView?
    var fetchedResultsController : NSFetchedResultsController<Delivery>
    weak var coordinator : DeliveryListCoordinator?
    var cellType : CellType
    
    init(collectionView : UICollectionView, fetchedResultsController : NSFetchedResultsController<Delivery>,
         coordinator : DeliveryListCoordinator?, cellType : CellType = .deliveryCell) {
        self.collectionView = collectionView
        self.fetchedResultsController = fetchedResultsController
        self.coordinator = coordinator
        self.cellType = cellType
    }
    
    func didSelectItemAtIndexPath(indexPath: IndexPath) {
        let detailViewController = DeliveryDetailViewController()
        detailViewController.delivery = fetchedResultsController.object(at: indexPath)
        guard let coordinator = self.coordinator else { return }
        coordinator.pushViewController(viewController: detailViewController)
    }
    
    func sizeForItemAtIndexPath(indexPath: IndexPath) -> CGSize {
        guard let collectionView = collectionView else { return CGSize.zero }
        return CGSize(width: collectionView.frame.size.width - (Constants.StandardSpacing.edges * 2),
                      height: cellType.height())
    }
}

