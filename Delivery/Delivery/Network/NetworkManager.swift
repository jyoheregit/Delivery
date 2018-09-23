//
//  NetworkManager.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import Alamofire

protocol Fetchable {
    
    func fetchDeliveries(offset : Int, limit : Int, completion : @escaping ([DeliveryModel]?, ErrorType?) ->())
}

enum ErrorType : Error {
    
    case noDataAvailable(String)
    case parsingError(String)
    case otherError(String)
    
    func associatedValue() -> Any {
        switch self {
        case .noDataAvailable(let value):
            return value
        case .parsingError(let value):
            return value
        case .otherError(let value):
            return value
        }
    }
}

class NetworkManager : Fetchable {
    
    func fetchDeliveries(offset : Int, limit : Int, completion : @escaping ([DeliveryModel]?, ErrorType?) ->()) {
    
        let url = "https://mock-api-mobile.dev.lalamove.com/deliveries?offset=\(offset)&limit=\(limit)"
        Alamofire
            .request(url)
            .responseJSON { (response) in
              
                guard response.result.isSuccess, let data = response.data else {
                    if let error = response.result.error {
                        completion(nil, ErrorType.otherError(error.localizedDescription))
                    }
                    return
                }
            
                do {
                    let decoder = JSONDecoder()
                    let deliveries = try decoder.decode([DeliveryModel].self, from: data)
                    deliveries.count > 0 ? completion(deliveries, nil) :
                                           completion(deliveries, ErrorType.noDataAvailable("No Data Available"))
                }
                catch {
                    completion(nil, ErrorType.parsingError("Error Parsing Deliveries"))
                }
        }
    }
}
