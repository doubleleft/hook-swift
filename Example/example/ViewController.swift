//
//  ViewController.swift
//  example
//
//  Created by Endel on 11/01/15.
//  Copyright (c) 2015 Doubleleft. All rights reserved.
//

import UIKit
import Hook

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var hook = Hook.Client(app_id: "1", key: "09c835703df4f78da6fffe957d2e2b6f", endpoint: "http://localhost:4665");
        var collection = hook.collection("something");
        hook.collection("hello");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

