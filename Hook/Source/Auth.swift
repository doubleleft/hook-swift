//
//  Auth.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Foundation;
import SwiftyJSON;

let AUTH_DATA_KEY : String = "hook-auth-data";
let AUTH_TOKEN_KEY : String = "hook-auth-token";
let AUTH_TOKEN_EXPIRATION : String = "hook-auth-token-expiration";

public class Auth {
    var client : Client;

    var currentUser : SwiftyJSON.JSON? = nil;

    init(client: Client) {
        self.client = client;

        let now = NSDate(),
            dateFormatter = NSDateFormatter(),
            tokenExpiration = dateFormatter.dateFromString(self.client.storage.get(self.client.app_id + "-" + AUTH_TOKEN_EXPIRATION)),
            currentUser = self.client.storage.get(self.client.app_id + "-" + AUTH_DATA_KEY);

        // Fill current user only when it isn't expired yet.
        if (currentUser != "" && (now.compare(tokenExpiration!) == NSComparisonResult.OrderedDescending)) {
            self.currentUser = SwiftyJSON.JSON(currentUser);
        }
    }

    public func getToken() -> String? {
        return self.client.storage.get(self.client.app_id + "-" + AUTH_TOKEN_KEY);
    }

    public func register(data: [String: AnyObject]? = nil) -> Request {
        var req = self.client.post("auth/email", data: data);

        req.onSuccess { (response) in
            self.registerToken(response);
        }

        return req;
    }

    public func login(data: [String: AnyObject]? = nil) -> Request {
        var req = self.client.post("auth/email/login", data: data);

        req.onSuccess { (response) in
            self.registerToken(response)
        }

        return req;
    }

    public func update(data: [String: AnyObject]) -> Request {
        if self.currentUser == nil {
            NSException(name: "not logged in.", reason: "NotLoggedIn", userInfo: nil).raise()
        }

        var currentUser = self.currentUser!;
        var req : Request = self.client.collection("auth").update(currentUser["_id"].string!, data: data)
        req.onSuccess { (response) in
            self.setCurrentUser(response)
            return
        };

        return req;
    }

    public func forgotPassword(data: [String: AnyObject]? = nil) -> Request {
        return self.client.post("auth/email/forgotPassword", data: data);
    }

    public func resetPassword(data: [String: AnyObject]? = nil) -> Request {
        // if !data.objectForKey("token") {
        //     NSException(name: "'token' is required to reset password.", reason: "MissingArgument", userInfo: nil).raise();
        // }

        // if !data.objectForKey("password") {
        //     NSException(name: "'password' is required to reset password.", reason: "MissingArgument", userInfo: nil).raise();
        // }

        return self.client.post("auth/email/resetPassword", data: data)
    }

    public func logout() -> Self {
        return self.setCurrentUser(nil);
    }

    public func setCurrentUser(newValue: SwiftyJSON.JSON?) -> Self {
        if newValue == nil {
            // TODO: trigger logout event
            // self.trigger('logout', self.currentUser);
            self.currentUser = nil;

            self.client.storage.remove(self.client.app_id + "-" + AUTH_TOKEN_KEY);
            self.client.storage.remove(self.client.app_id + "-" + AUTH_DATA_KEY);

        } else {
            self.client.storage.set(self.client.app_id + "-" + AUTH_DATA_KEY, value: newValue!.string!);
            self.currentUser = newValue!;

            // TODO: trigger login event
            // self.trigger('login', data);
        }

        return self;
    }

    func registerToken(data : SwiftyJSON.JSON) {
        if data["token"].stringValue != "" {
            self.client.storage.set(self.client.app_id + "-" + AUTH_TOKEN_KEY, value: data["token"]["token"].stringValue);
            self.client.storage.set(self.client.app_id + "-" + AUTH_TOKEN_EXPIRATION, value: data["token"]["expire_at"].stringValue);

            // data["token"] = nil;
            self.currentUser = data;
        }
    }

}
