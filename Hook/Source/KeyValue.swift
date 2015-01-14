//
//  KeyValue.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

public class KeyValue {
    var client : Client;

    init(client: Client) {
        self.client = client
    }

    public func get(key : String) -> Request {
        return self.client.get("key/" + key);
    }

    public func set(key : String, value : AnyObject) -> Request {
        return self.client.post("key/" + key, data: [ "value": value ]);
    }


}
