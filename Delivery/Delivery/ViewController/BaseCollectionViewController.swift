//
//  BaseCollectionViewController.swift
//  Delivery
//
//  Created by Joe on 17/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit
import CoreData

class BaseCollectionViewController : BaseViewController {
    
    var collectionViewDataSource : CollectionViewDataSource?
    var collectionViewDelegate : CollectionViewDelegate?
    var displayRefreshControl = false
    
    var isPaginationRequired = false
    var fetchingMoreData = false
    var offset = 0
    var numberOfPages = 20 //Need to get from API
    let numberOfItemsToFetch = 20
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 16, right: 0)
        return collectionView
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Delivery> = {
        let fetchedResultsController = CoreDataManager.shared.fetchedResultsController
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    lazy var blockOperations: [BlockOperation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupDelegate()
    }
    
    override func setupUI(){
        super.setupUI()
        registerCell()
        view.addSubview(collectionView)
        collectionView.matchSuperView()
        if(displayRefreshControl == true) { collectionView.addSubview(refreshControl) }
    }
    
    func registerCell() { }
    func setupDataSource() { }
    func setupDelegate() { }
    func fetchMoreData() { }
    
    deinit {
        blockOperations.forEach { $0.cancel() }
        blockOperations.removeAll(keepingCapacity: false)
    }
}

// MARK: UICollectionViewDataSource

extension BaseCollectionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = collectionViewDataSource else { return 0 }
        let numberOfItems = dataSource.numberOfItemsInSection()
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let dataSource = collectionViewDataSource else {
            fatalError("DataSource Not set")
        }
        return dataSource.cellForItemAtIndexPath(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        guard isPaginationRequired,
            let noOfDeliveries = self.fetchedResultsController.sections?.first?.numberOfObjects else {
            return
        }
        
        if !fetchingMoreData && (indexPath.row == noOfDeliveries - 10){
            fetchingMoreData = true
            fetchMoreData()
        }
    }
   
}

// MARK: UICollectionViewDelegate

extension BaseCollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionViewDelegate = self.collectionViewDelegate else { return }
        collectionViewDelegate.didSelectItemAtIndexPath(indexPath: indexPath)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension BaseCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let delegate = collectionViewDelegate else { return CGSize.zero }
        return delegate.sizeForItemAtIndexPath(indexPath: indexPath)
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension BaseCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let operation: BlockOperation
        
        switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                operation = BlockOperation { self.collectionView.insertItems(at: [newIndexPath]) }
            
            case .delete:
                guard let indexPath = indexPath else { return }
                operation = BlockOperation { self.collectionView.deleteItems(at: [indexPath]) }
            
            case .move:
                guard let indexPath = indexPath,  let newIndexPath = newIndexPath else { return }
                operation = BlockOperation { self.collectionView.moveItem(at: indexPath, to: newIndexPath) }
            
            case .update:
                guard let indexPath = indexPath else { return }
                operation = BlockOperation { self.collectionView.reloadItems(at: [indexPath]) }
        }
        
        blockOperations.append(operation)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
}


