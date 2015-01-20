//
//  HookTests.swift
//  HookTests
//
//  Created by Endel on 18/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import XCTest
import Hook

class HookCollectionTests: XCTestCase {
    
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
            XCTAssertNotNil(data["_id"].int, "Object must have an Id")
            
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
        var expectation = expectationWithDescription("delete")
        
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
            
        }.onError({ (data) in
            XCTFail("Ops, something wen't wrong and we couldn't create this item")
            expectation.fulfill()
        })
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
    func testObjectCounting() {
        var expectation = expectationWithDescription("count")
        
        hook?.collection("items").create([ "type": "toCount" ]).onSuccess{ (data) in
            println(".")
            self.hook?.collection("items").filter(["type": "toCount"]).count().onSuccess{ (data) in
                XCTAssertGreaterThan(data.int!, 0, "Count must be greater then 0");
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

    func testObjectFiltering() {
        var expectation = expectationWithDescription("filter")
        
        hook?.collection("items").create([ "type": "toFilter" ]).onSuccess{ (data) in
            println(".")
            self.hook?.collection("items").filter(["type": "toFilter"]).onSuccess{ (data) in
            
                var allEqual = true
                for item in data.arrayValue {
                    if item["type"].string != "toFilter" {
                        allEqual = false
                    }
                }
                XCTAssertTrue(allEqual, "Filter returned unexpected items!")
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
    
    func testConnectionError() {
        var expectation = expectationWithDescription("credentialsError")
        
        var hook = Hook.Client(app_id: "1", key: "-", endpoint: "asdasdadsasd");
        hook.collection("items").create([ "name": "invalidCredentials"]).onSuccess({ (data) in
            XCTFail("Can't call onSuccess with invalid auth-key")
            
            expectation.fulfill()
        }).onError({ (data) in
            XCTAssert(true, "Called onError with invalid URL")
            
            expectation.fulfill()
        })
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
    func testCredentialsError() {
        var expectation = expectationWithDescription("credentialsError")
        
        var hook = Hook.Client(app_id: "1", key: "09c835703df4f78da6fffe957d2e2b61", endpoint: "http://localhost:4665/");
        hook.collection("items").create([ "name": "invalidCredentials"]).onSuccess({ (data) in
            XCTFail("Can't call onSuccess with invalid auth-key")
            
            expectation.fulfill()
        }).onError({ (data) in
            XCTAssert(true, "Called onError with invalid auth-key")
            
            expectation.fulfill()
        })
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
    
}
