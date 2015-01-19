//
//  Request.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Alamofire;
import Foundation;
//import SwiftyJSON;

public class Request {

    var request : Alamofire.Request;

    public init(url : String, method: Alamofire.Method, headers: [String: String], data : [String: AnyObject]? = nil) {
        let manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = headers
        self.request = Alamofire.request(method, url, parameters: data, encoding: Alamofire.ParameterEncoding.JSON)
    }

    public func execute() -> Self {
        return self;
    }

    public func onSuccess(completionHandler: (JSON) -> Void) -> Self {
        self.request.responseString { (request, response, str, error) in
            if let data = str?.dataUsingEncoding(NSUTF8StringEncoding) {
                completionHandler(JSON(data: data));
            } else {
                println("SOMETHING IS WRONG \(str)")
            }
        }
        return self
    }

    public func onError(completionHandler: (JSON) -> Void) -> Self {
        self.request.responseString { (request, response, str, error) in
            if let data = str?.dataUsingEncoding(NSUTF8StringEncoding) {
                completionHandler(JSON(data: data));
            }
        }
        return self
    }

    // alias to onError
    public func onFail(completionHandler: (JSON) -> Void) -> Self {
        return self.onError(completionHandler)
    }

    public func onComplete(completionHandler: (JSON) -> Void) -> Self {
        self.request.responseString { (request, response, str, error) in
            if error == nil {
                if let data = str?.dataUsingEncoding(NSUTF8StringEncoding) {
                    completionHandler(JSON(data: data));
                }
            } else {
                completionHandler(JSON.nullJSON);
            }
        }
        return self;
    }

    public func suspend() {
        self.request.suspend()
    }

    public func resume() {
        self.request.resume()
    }

    public func cancel() {
        self.request.cancel()
    }

}
