//
//  Client.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Foundation;
import Alamofire;

public class Client {

    var endpoint : String = "http://localhost:4665/",
        app_id : String,
        key : String;

    var auth : Auth {
        return Auth(client: self);
    };

    var keys : KeyValue {
        return KeyValue(client: self);
    };

    var system : System {
        return System(client: self);
    };

    public init(app_id : String, key : String, endpoint : String = "http://localhost:4665/") {
        self.app_id = app_id;
        self.key = key;
        self.endpoint = endpoint;
    }

    public func collection(name: String) -> Collection {
        return Collection(client: self, name: name);
    }

    public func channel(name: String, options: AnyObject?) {
        NSException(name: "NotImplementedException", reason: "Not implemented.", userInfo: nil).raise();
    }

    public func post(segments: String, data: [String: AnyObject]? = nil) -> Request {
        return self.request(segments, method: Alamofire.Method.POST, data: data);
    }

    public func get(segments: String, data: [String: AnyObject]? = nil) -> Request {
        return self.request(segments, method: Alamofire.Method.GET, data: data);
    }

    public func put(segments: String, data: [String: AnyObject]? = nil) -> Request {
        return self.request(segments, method: Alamofire.Method.PUT, data: data);
    }

    public func remove(segments: String, data: [String: AnyObject]? = nil) -> Request {
        return self.request(segments, method: Alamofire.Method.DELETE, data: data);
    }

    func request(segments: String, method: Alamofire.Method, data: [String: AnyObject]? = nil) -> Request {
        var req = Request(url: self.endpoint + segments, method: method, headers: self.getHeaders(), data: self.getPayload(data));
        return req.execute();
    }

    private func getHeaders() -> [String: String] {
        var headers = [
                "X-App-Id": self.app_id,
                "X-App-Key": self.key
            ],
            authToken = self.auth.getToken();

        if authToken != nil {
            let token : String = authToken! as String;
            headers["X-Auth-Token"] = token;
        }

        return headers;
    }

    private func getPayload(data : [String: AnyObject]?) -> [String: AnyObject]? {
        return data;
    }

}
