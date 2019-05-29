//
//  RealmManager.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/29/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private let realm = try! Realm()
    
    private init() { }
    
    func write(_ history: ParkingHistory) {
        do {
            try realm.write {
                realm.add(history, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ history: ParkingHistory) {
        do {
            try realm.write {
                realm.delete(history)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getHistory() -> Results<ParkingHistory> {
        return realm.objects(ParkingHistory.self).sorted(byKeyPath: "startDate")
    }
    
    
}
