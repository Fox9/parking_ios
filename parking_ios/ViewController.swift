//
//  ViewController.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/27/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationManager.shared.start()
    }
}

