//
//  Collection.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

public class Collection {
    var client : Client,
        name : String;

    init(client: Client, name: String) {
        self.client = client;
        self.name = name;
    }

}
