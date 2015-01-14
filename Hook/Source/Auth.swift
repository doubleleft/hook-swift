//
//  Auth.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

let AUTH_DATA_KEY : String = "hook-auth-data";
let AUTH_TOKEN_KEY : String = "hook-auth-token";
let AUTH_TOKEN_EXPIRATION : String = "hook-auth-token-expiration";

public class Auth {
    var client : Client;
    var currentUser : [String: AnyObject]? = nil;

    init(client: Client) {
        self.client = client
    }

    public func getToken() -> String? {
        return nil;
    }
}
