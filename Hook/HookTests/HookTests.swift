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
        hook = Hook.Client(app_id: "1", key: "09c835703df4f78da6fffe957d2e2b6f", endpoint: "http://127.0.0.1:4665/");
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testObjectCreation() {
        var expectation = expectationWithDescription("create")
        
        hook?.collection("items").create([
                "name": "Hello there!"
        ]).onSuccess({ (data) in
            XCTAssert(true, "Object created successfully")
            XCTAssert(data != nil, "Created object must be returned")
            
            if let name = data["name"].string {
                XCTAssertEqual(name, "Hello there!", "Object created must have values sent")
            } else {
                XCTFail("Can't retrieve 'name' key of object");
            }
            XCTAssertNotNil(data["_id"].string, "Object must have an Id")
            
            expectation.fulfill()
        }).onError({ (data) in
            XCTAssert(false, "Can't create object")
            
            expectation.fulfill()
        });
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
    func testObjectDeletion() {
        var expectation = expectationWithDescription("create")
        
        hook?.collection("items").create([
            "type": "toDelete"
        ]).onSuccess{ (data) in
            
            let _id = data["_id"].int
            if (_id != nil) {
                self.hook?.collection("items").remove(_id: _id!).onSuccess{ (data) in
                    XCTAssert(true, "Item deleted");
                }.onError{ (data) in
                    XCTFail("Can't delete item");
                }
                expectation.fulfill()
            } else {
                XCTFail("Can't delete an item without an _id")
                expectation.fulfill()
            }
            
        }
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
    func testObjectCounting() {
        var expectation = expectationWithDescription("create")
        
        hook?.collection("items").create([ "type": "toCount" ]).onSuccess{ (data) in
            if (data != nil) {
                self.hook?.collection("items").count().onSuccess{ (data) in
                    XCTAssertNotNil(data.int, "Count must return something");
                    expectation.fulfill()
                }
            } else {
                XCTFail("Can't create test item")
            }
            
        }
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
}
