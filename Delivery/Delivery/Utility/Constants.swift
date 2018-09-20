//
//  Constants.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import UIKit

enum CellType {
    case deliveryCell
    case mapViewCell
    
    func height() -> CGFloat{
        
        switch self {
            
        case .deliveryCell:
            return Constants.ImageView.height
        case .mapViewCell:
            return 300
        }
    }
}

struct Constants {
    
    struct StandardSpacing {
        static let edges : CGFloat = 16.0
        static let between : CGFloat  = 8.0
    }
    
    struct ImageView {
        static let width : CGFloat = 121.0
        static let height : CGFloat = 81.0
    }
    
    struct Title {
        static let deliveryList = "Things to Deliver"
        static let deliveryDetail = "Delivery Details"
    }
    
}
