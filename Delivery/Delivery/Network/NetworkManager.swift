//
//  NetworkManager.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    let url = "https://mock-api-mobile.dev.lalamove.com/deliveries?offset=0&limit=20"
    
    func fetchDeliveries(completion : @escaping ([DeliveryModel]?, Error?) ->()) {
        
        Alamofire
            .request(url)
            .responseJSON { (response) in
                
                guard let data = response.data else {
                    completion(nil, response.error)
                    return
                }
               
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    let decoder = JSONDecoder()
                    let deliveries = try decoder.decode([DeliveryModel].self, from: data)
                    completion(deliveries, response.error)
                }
                catch {
                    completion(nil, response.error)
                }
        }
    }
    
}
