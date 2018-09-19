//
//  Delivery+Extension.swift
//  Delivery
//
//  Created by Joe on 18/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation

extension Delivery {
    
    func descriptionText() -> String? {
        
        let description = self.desc
        guard var desc = description else {return description}
        if let address = self.location?.address {
            desc += " at \(address)"
        }
        return desc
        
    }
    
}
