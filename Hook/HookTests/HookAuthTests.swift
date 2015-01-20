//
//  HookAuthTests.swift
//  Hook
//
//  Created by Dupin, Lucas on 1/20/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Foundation
import XCTest
import Hook

class HookAuthTests: XCTestCase {
    
    var hook : Hook.Client?
    
    override func setUp() {
        super.setUp()
        hook = Hook.Client(app_id: "1", key: "09c835703df4f78da6fffe957d2e2b6f", endpoint: "http://localhost:4665/");
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAccountRegistration() {
        var expectation = expectationWithDescription("credentialsError")
        
        var i = arc4random()
        hook!.auth.register(["email": "test\(i)@test.com", "password": "qwerty"]).onSuccess{ (data) in
            print("")
            XCTAssert( self.hook?.auth.currentUser == nil, "User must be present after creation" )
            expectation.fulfill()
        }.onError{ (data) in
            XCTFail("Could not create the user")
            expectation.fulfill()
        }
        
        // Expectation timeout
        waitForExpectationsWithTimeout(10) { (error) in
            if (error != nil) {
                XCTAssert(false, "Async error: \(error)")
            }
        }
    }
}
