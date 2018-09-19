//
//  DeliveryListCoordinator.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

class DeliveryListCoordinator : NSObject {    
   
    private var deliveryListViewController : DeliveryListViewController
    
    override init() {
        deliveryListViewController = DeliveryListViewController()
        super.init()
        configureViewController()
    }
    
    func configureViewController() {
        deliveryListViewController.networkManager = NetworkManager()
        deliveryListViewController.coordinator =  self
    }
    
    func mainViewController() -> DeliveryListViewController {
        return deliveryListViewController
    }
    
    func navigationViewController() -> UINavigationController {
        return UINavigationController(rootViewController: deliveryListViewController)
    }
    
    func pushViewController(viewController : UIViewController){
        deliveryListViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentViewController(viewController : UIViewController){
        deliveryListViewController.present(viewController, animated: true, completion: nil)
    }
}
