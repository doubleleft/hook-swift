//
//  HookTests.swift
//  HookTests
//
//  Created by Endel on 18/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import XCTest
import Hook

class HookTests: XCTestCase {
    
    var hook : Hook.Client?
    
    override func setUp() {
        super.setUp()
        hook = Hook.Client(app_id: "1", key: "09c835703df4f78da6fffe957d2e2b6f", endpoint: "http://localhost:4665/");
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testObjectCreation() {
        var expectation = expectationWithDescription("create")
        
        var req = hook?.collection("items").create([
                "name": "Hello there!"
        ]).onSuccess({ (data) in
            XCTAssert(true, "Object created successfully")
            XCTAssert(data != nil, "Created object must be returned")
            
            if let name = data["name"].string {
                XCTAssertEqual(name, "Hello there!", "Object created must have values sent")
            } else {
                XCTFail("Can't retrieve 'name' key of object");
            }
            
            
            //expectation.fulfill()
        }).onError({ (data) in
            XCTAssert(false, "Can't create object")
            
            //expectation.fulfill()
        });
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
}
