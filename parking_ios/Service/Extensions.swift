//
//  Extensions.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
