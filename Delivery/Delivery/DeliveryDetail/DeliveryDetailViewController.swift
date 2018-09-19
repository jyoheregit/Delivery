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
    
    override func setupUI(){
        super.setupUI()
    }
    
    override func registerCell() {
        collectionView.register(MapViewCell.self, forCellWithReuseIdentifier: "MapViewCell")
        collectionView.register(DeliveryCell.self, forCellWithReuseIdentifier: "DeliveryCell")
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


