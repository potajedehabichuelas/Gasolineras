//
//  GasolinerasTests.swift
//  GasolinerasTests
//
//  Created by Daniel Bolivar herrera on 2/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import XCTest

class StorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCoreData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        print("Attempting to retrieve petrol stations from Internet")
        // Request petrol station data
        NetworkManager.sharedInstance.requestSpanishPetrolStationData();
        
        print("Attempting to retrieve petrol stations from Core Data")
        //Test
        let result = Storage.getPetrolStations(0, long: 0, range: 0);
        
        if result?.count > 0 {
            XCTFail("Failed : Function returned nil")
        } else {
            XCTFail("Failed : Function returned nil")
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
