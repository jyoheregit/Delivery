//
//  CollectionViewContract.swift
//  Delivery
//
//  Created by Joe on 17/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

protocol CollectionViewDataSource : class {
    
    func numberOfItemsInSection() -> Int
    func cellForItemAtIndexPath(indexPath: IndexPath) -> UICollectionViewCell
}

protocol CollectionViewDelegate : class {

    func didSelectItemAtIndexPath(indexPath: IndexPath)
    func sizeForItemAtIndexPath(indexPath: IndexPath) -> CGSize
}
