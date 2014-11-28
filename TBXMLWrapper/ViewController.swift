//
//  ViewController.swift
//  TBXMLWrapper
//
//  Created by simeon on 25/11/14.
//  Copyright (c) 2014 simeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSBundle.mainBundle().URLForResource("HR_BANNERSANDICONS", withExtension: "xml")
        let data = NSData(contentsOfURL: url!)
        let dataHandler = DataHandler()
        if let d = data {
            dataHandler.mappingData(d)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

