//
//  Collection.swift
//  hook
//
//  Created by Endel on 10/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Foundation;

public class Collection {
    var client : Client,
        name : String,
        segments : String,

        options : [String: AnyObject?] = [String: AnyObject?](),
        wheres : [[AnyObject?]] = [],
        ordering : [[String]] = [],
        _group : [String] = [],
        _limit : UInt? = nil,
        _offset : UInt? = nil,
        _remember : UInt? = nil;

    init(client: Client, name: String) {
        self.client = client;
        self.name = name;
        self.segments = "collection/" + self.name;
    }

    func reset() {
        self.options = [String: AnyObject?]();
        self.wheres = [];
        self.ordering = [];
        self._group = [];
        self._limit = nil;
        self._offset = nil;
        self._remember = nil;
    }

    public func create(data : [String: AnyObject?]) -> Request {
        return self.client.post(self.segments, data: data);
    }

    public func get() -> Request {
        return self.client.get(self.segments, data: self.buildQuery());
    }

    public func find(_id : AnyObject) -> Request {
        return self.client.get(self.segments + "/" + (_id as String), data: self.buildQuery());
    }

    public func count(field : AnyObject? = nil) -> Request {
        var _field : String = (field is String) ? field as String : "*";
        self.options["aggregation"] = ["method": "count", "field": _field];
        return self.get();
    }

    public func max(field : String) -> Request {
        self.options["aggregation"] = ["method": "max", field: field];
        return self.get();
    }

    public func min(field : String) -> Request {
        self.options["aggregation"] = ["method": "min", field: field];
        return self.get();
    }

    public func avg(field : String) -> Request {
        self.options["aggregation"] = ["method": "avg", field: field];
        return self.get();
    }

    public func sum(field : String) -> Request {
        self.options["aggregation"] = ["method": "sum", field: field];
        return self.get();
    }

    public func first() -> Request {
        self.options["first"] = 1;
        return self.get();
    }

    public func firstOrCreate(data : [String: AnyObject?]) -> Request {
        self.options["first"] = 1;
        self.options["data"] = data as [String : AnyObject];
        return self.client.post(self.segments, data: self.buildQuery());
    }

    public func remove(_id : AnyObject? = nil) -> Request {
        var path : String = self.segments;
        if (_id != nil) {
            let _idString : String = _id! as String;
            path += "/" + _idString;
        }
        return self.client.remove(path, data: self.buildQuery());
    }

    public func update(_id : String, data : [String: AnyObject?]) -> Request {
        return self.client.post(self.segments + "/" + _id, data: data);
    }

    public func increment(field : String, value : Int = 1) -> Request {
        self.options["operation"] = ["method": "increment", field: field, value: value];
        return self.client.put(self.segments, data: self.buildQuery());
    }

    public func decrement(field : String, value : Int = 1) -> Request {
        self.options["operation"] = ["method": "increment", field: field, value: value];
        return self.client.put(self.segments, data: self.buildQuery());
    }

    public func updateAll(data : [String: AnyObject?]) -> Request {
        self.options["data"] = data as [String : AnyObject];
        return self.client.put(self.segments, data: self.buildQuery());
    }

    public func select(fields : String...) -> Collection {
        self.options["select"] = fields;
        return self;
    }

    public func filter(field : String, value : AnyObject, boolean : String = "and") -> Collection {
        return self.addFilter(field, operation: "=", value: value, boolean: boolean);
    }

    public func filter(field : String, operation : String, value : AnyObject, boolean : String = "and") -> Collection {
        return self.addFilter(field, operation: "=", value: value, boolean: boolean);
    }

    public func filter(fields : [String: AnyObject?]) -> Collection {
        for (field, value) in fields {
            return self.addFilter(field, operation: "=", value: value);
        }
        return self;
    }

    public func orFilter(field : String, value : AnyObject) -> Collection {
        return self.addFilter(field, operation: "=", value: value, boolean: "or");
    }

    public func orFilter(field : String, operation : String, value : AnyObject) -> Collection {
        return self.addFilter(field, operation: operation, value: value, boolean: "or");
    }

    public func join(fields : String...) -> Collection {
        self.options["with"] = fields
        return self
    }

    public func distinct() -> Collection {
        self.options["distinct"] = true
        return self
    }

    public func group(fields : String...) -> Collection {
        self._group = fields;
        return self;
    }

    public func sort(field : String, direction : Int = 1) -> Collection {
        self.ordering.append([field, (direction == -1) ? "desc" : "asc"]);
        return self;
    }

    public func sort(field : String, direction : String) -> Collection {
        self.ordering.append([field, direction.lowercaseString]);
        return self;
    }

    public func limit(i : UInt) -> Collection {
        self._limit = i;
        return self;
    }

    public func offset(i : UInt) -> Collection {
        self._offset = i;
        return self;
    }

    public func remember(i : UInt) -> Collection {
        self._remember = i;
        return self;
    }

    /* public func channel(options) { */
    /* } */

    func addFilter(field : String, operation : String, value : AnyObject?, boolean : String = "and") -> Collection {
        self.wheres.append([field, operation.lowercaseString, value, boolean]);
        return self;
    }

    func buildQuery() -> [String: AnyObject] {
        var query : [String: AnyObject] = [String: AnyObject]();

        // apply limit / offset and remember
        if (self._limit != nil) { query["limit"] = self._limit; }
        if (self._offset != nil) { query["offset"] = self._offset; }
        if (self._remember != nil) { query["remember"] = self._remember; }

        // apply wheres
        if (self.wheres.count > 0) {
            var q : [AnyObject?] = [AnyObject?]();
            for arr : [AnyObject?] in self.wheres {
                q.append(arr);
            }
            query["q"] = [];
        }

        // apply ordering
        if (self.ordering.count > 0) {
            query["s"] = self.ordering;
        }

        // apply group
        if (self._group.count > 0) {
            query["g"] = self._group;
        }

        var shortnames = [
            "paginate": "p",        /* pagination (perPage) */
            "first": "f",           /* first / firstOrCreate */
            "aggregation": "aggr",  /* min / max / count / avg / sum */
            "operation": "op",      /* increment / decrement */
            "data": "data",         /* updateAll / firstOrCreate */
            "with": "with",         /* join / relationships */
            "select": "select",     /* fields to return */
            "distinct": "distinct"  /* use distinct operation */
        ];

        for (short, long) in shortnames {
            if (self.options[long] != nil) {
                query[short] = self.options[long]!;
            }
        }

        // clear wheres/ordering for future calls
        self.reset();

        return query;
    }

}
