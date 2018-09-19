//
//  Model.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation

struct DeliveryModel : Codable {
    var id : Int64?
    var description : String?
    var imageUrl : String?
    var location : DeliveryLocation?
}

struct DeliveryLocation : Codable {
    var latitude : Double?
    var longitude : Double?
    var address : String?
    
    enum CodingKeys : String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case address
    }
}
