//
//  BaseVC.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var isNavigationBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }

}
