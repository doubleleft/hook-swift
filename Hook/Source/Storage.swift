//
//  Storage.swift
//  hook
//
//  Created by Endel on 17/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import Foundation;
import SQLite;

public class Storage {
    var db : SQLite.Database;

    public init(id : String) {
        // get application documents directory, which we have write access.
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String

        // create database instance
        self.db = Database("\(path)/hook-" + id + ".sqlite3");

        var stmt = self.db.prepare("CREATE TABLE IF NOT EXISTS config (\"id\", \"value\", PRIMARY KEY(\"id\"))");
        stmt.run();
    }

    public func get(name : String) -> String {
        for row in self.db.prepare("SELECT value FROM config WHERE id = \"" + name + "\"") {
            return row[0] as String;
        }

        return "";
    }

    public func set(name : String, value : String) -> Bool {
        let insertStmt = self.db.prepare("INSERT OR IGNORE INTO config (id, value) VALUES (?, ?)");
        insertStmt.run(name, value)

        let updateStmt = self.db.prepare("UPDATE config SET value = ? WHERE id= ?");
        updateStmt.run(value, name)

        return true;
    }

    public func remove(name : String) -> Bool {
        let stmt = self.db.prepare("DELETE FROM config WHERE id = ?");
        stmt.run(name);

        return true;
    }

}
