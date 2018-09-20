//
//  DeliveryDetailContract.swift
//  Delivery
//
//  Created by Joe on 18/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

class DeliveryDetailDataSource : CollectionViewDataSource {
    
    weak var collectionView: UICollectionView?
    weak var delivery : Delivery?
    var cellTypes : [CellType]
    
    init(collectionView : UICollectionView, cellTypes : [CellType], delivery : Delivery?) {
        self.collectionView = collectionView
        self.cellTypes = cellTypes
        self.delivery = delivery
    }
    
    func numberOfItemsInSection() -> Int {
        
        guard let _ = delivery, let _ = collectionView else { return 0 }
        return cellTypes.count
    }
    
    func cellForItemAtIndexPath(indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionView = self.collectionView else { fatalError("Collection view is nil") }

        let cellType = cellTypes[indexPath.row]
    
        switch cellType {
            
            case .mapViewCell:
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MapViewCell
                cell.delivery = delivery
                return cell
            
            case .deliveryCell:
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DeliveryCell
                cell.delivery = delivery
                return cell
        }
    }
}

class DeliveryDetailDelegate : CollectionViewDelegate {
    
    weak var collectionView: UICollectionView?
    weak var delivery : Delivery?
    var cellTypes : [CellType]
    
    init(collectionView : UICollectionView, cellTypes : [CellType], delivery : Delivery?) {
        self.collectionView = collectionView
        self.cellTypes = cellTypes
        self.delivery = delivery
    }
    
    func didSelectItemAtIndexPath(indexPath: IndexPath) { }
    
    func sizeForItemAtIndexPath(indexPath: IndexPath) -> CGSize {
        
        guard let collectionView = collectionView else { return CGSize.zero }
        let cellType = cellTypes[indexPath.row]
        
        switch cellType {
            case .mapViewCell:
                return CGSize(width: collectionView.frame.size.width, height: cellType.height())
            case .deliveryCell:
                return CGSize(width: collectionView.frame.size.width - (Constants.StandardSpacing.edges * 2),
                              height: cellType.height())
        }
    }
}


