//
//  DeliveryDetailViewController.swift
//  Delivery
//
//  Created by Joe on 17/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

class DeliveryDetailViewController: BaseCollectionViewController {

    var delivery : Delivery?
    lazy var cellTypes : [CellType] = [.mapViewCell, .deliveryCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Custom Overrides

    override func setupUI(){
        super.setupUI()
        collectionView.contentInset = UIEdgeInsets.zero
    }
    
    override func title() -> String? {
        return Constants.Title.deliveryDetail
    }
    
    override func registerCell() {
        collectionView.register(cell: MapViewCell.self)
        collectionView.register(cell: DeliveryCell.self)
    }
    
    override func setupDataSource() {
        let dataSource = DeliveryDetailDataSource(collectionView: collectionView, cellTypes: cellTypes, delivery: delivery)
        self.collectionViewDataSource = dataSource
    }
    
    override func setupDelegate() {
        let delegate = DeliveryDetailDelegate(collectionView: collectionView, cellTypes: cellTypes, delivery: delivery)
        self.collectionViewDelegate = delegate
    }
}


