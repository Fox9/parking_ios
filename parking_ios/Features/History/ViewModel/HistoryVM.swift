//
//  HistoryVM.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/29/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation

class HistoryVM {
    
    var parkingHistory = RealmManager.shared.getHistory()
    
    func delete(_ history: ParkingHistory) {
        RealmManager.shared.delete(history)
    }
}
