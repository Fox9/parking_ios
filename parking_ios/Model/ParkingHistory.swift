//
//  ParkingHistory.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/29/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation
import RealmSwift

class ParkingHistory: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var parking: Parking? = nil
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
