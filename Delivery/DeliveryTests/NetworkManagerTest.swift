//
//  NetworkManagerTest.swift
//  DeliveryTests
//
//  Created by Joe on 22/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import XCTest
import Mockingjay

class NetworkManagerTest: XCTestCase {

    var sut : Fetchable!
    var url = "https://mock-api-mobile.dev.lalamove.com/deliveries?offset=0&limit=2"
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }

    func matcher(request:URLRequest) -> Bool {
        return true
    }

    func testFetchDeliverySuccess() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "deliverySuccess", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        stub(matcher, jsonData(data))
        
        sut.fetchDeliveries(offset: 0, limit: 2, completion: { (deliveryModel, error) in
            
            XCTAssertNotNil(deliveryModel)
            XCTAssert(deliveryModel?.count == 2)
            
            var model = deliveryModel![0]
            XCTAssertEqual(model.id, 0)
            XCTAssertEqual(model.description, "Deliver documents to Andrio")
            XCTAssertEqual(model.imageUrl, "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-4.jpeg")
            XCTAssertNotNil(model.location)
            
            var location = model.location!
            XCTAssertEqual(location.latitude, 22.336093)
            XCTAssertEqual(location.longitude, 114.155288)
            XCTAssertEqual(location.address, "Cheung Sha Wan")
            
            model = deliveryModel![1]
            XCTAssertEqual(model.id, 1)
            XCTAssertEqual(model.description, "Deliver wine to Kenneth")
            XCTAssertEqual(model.imageUrl, "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-4.jpeg")
            XCTAssertNotNil(model.location)
            
            location = model.location!
            XCTAssertEqual(location.latitude, 22.336094)
            XCTAssertEqual(location.longitude, 114.155289)
            XCTAssertEqual(location.address, "Cheung Sha Wan")
        })
    }
    
    func testFetchDeliveryWithEmptyItems() {
        
        let data = try! Data([])
        stub(matcher, jsonData(data))
        
        sut.fetchDeliveries(offset: 0, limit: 2, completion: { (deliveryModel, error) in
            
            XCTAssertNotNil(error)
            XCTAssertNil(deliveryModel)
        })
    }
    
    //Using only one item, but not within array
    func testFetchDeliveryParsingError() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "parsingError", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        stub(matcher, jsonData(data))
        
        sut.fetchDeliveries(offset: 0, limit: 2, completion: { (deliveryModel, error) in
            
            XCTAssertNotNil(error)
            XCTAssertNil(deliveryModel)
            XCTAssertEqual(error?.associatedValue() as! String, "Error Parsing Deliveries")
        })
    }
    
    override func tearDown() {  }
}
