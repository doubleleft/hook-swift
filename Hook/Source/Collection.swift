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

    public func create(data) {}

    public func select() {}

    public func get() {}

    public func where(objects, _operation, _value, _boolean) {}

    public func orWhere(objects, _operation, _value) {}

    public func find(_id) {}

    public func join() {}

    public func distinct() {}

    public func group() {}

    public func count(field) {}

    public func max(field) {}

    public func min(field) {}

    public func avg(field) {}

    public func sum(field) {}

    public func first() {}

    public func firstOrCreate(data) {}

    public func then() {}

    public func reset() {}

    public func sort(field, direction) {}

    public func limit(int) {}

    public func offset(int) {}

    public func remember(minutes) {}

    public func channel(options) {}

    public func drop() {}

    public func remove(_id) {}

    public func update(_id, data) {}

    public func increment(field, value) {}

    public func decrement(field, value) {}

    public func updateAll(data) {}

    func addWhere(field, operation, value, boolean) {}

    func buildQuery() {}

}
