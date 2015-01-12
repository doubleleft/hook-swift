//
//  Request.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Alamofire;

public class Request {

    var request : Alamofire.Request? = nil;

    public init(url : String, method: String, headers: [String: String?], data : [String: AnyObject?]? = nil) {
        let endpointUrl = NSURL(string: url);

        let mutableURLRequest = NSMutableURLRequest(URL: endpointUrl!)
        mutableURLRequest.HTTPMethod = method;

        for (name, value) in headers {
            mutableURLRequest.setValue(value, forHTTPHeaderField: name)
        }

        var manager = Alamofire.Manager.sharedInstance;
        self.request = manager.request(ParameterEncoding.JSON.encode(mutableURLRequest, parameters: data).0)
    }

    public func execute() -> Request {
        return self;
    }

    public func onSuccess() {
    }

    public func onError() {
    }

    public func onComplete() {
    }

    public func suspend() {
        self.request?.suspend()
    }

    public func resume() {
        self.request?.resume()
    }

    public func cancel() {
        self.request?.cancel()
    }

}
