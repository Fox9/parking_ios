//
//  WaitingManager.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation
import MapKit

protocol WaitingManagerDelegate: class {
    func waitingManager(_ manager: WaitingManager, didEnterTo parking: Parking)
    func waitingManager(_ manager: WaitingManager, didStart time: Date)
    func waitingManager(_ manager: WaitingManager, didLeaveFrom parking: Parking, with time: Int)
}

class WaitingManager {
    
    weak var delegate: WaitingManagerDelegate?
    
    static let shared = WaitingManager()
    
    private var startDate: Date? {
        didSet {
            guard let startDate = startDate else { return }
            self.delegate?.waitingManager(self, didStart: startDate)
        }
    }
    private var parking: [Parking] = []
    private var currentParking: Parking?
    private var polygonRenderer: MKPolygonRenderer?
    
    private init() { }
    
    func add(parking: [Parking]) {
        self.parking = parking
    }
    
    func changeLocation(currnetLocation: CLLocationCoordinate2D) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let currentParking = self.currentParking {
                let mapPoint: MKMapPoint = MKMapPoint(currnetLocation)
                let polygonViewPoint: CGPoint = self.polygonRenderer!.point(for: mapPoint)
                guard !self.polygonRenderer!.path.contains(polygonViewPoint) else { return }
                if let startDate = self.startDate {
                    self.delegate?.waitingManager(self, didLeaveFrom: currentParking,
                                                  with: Calendar.current.compare(Date(), to: startDate, toGranularity: .second).rawValue)
                }
                self.removeCurrentParking()
            } else {
                self.checkIfInParking(location: currnetLocation)
            }
        }
    }
    
    private func removeCurrentParking() {
        self.startDate = nil
        self.polygonRenderer = nil
        self.currentParking = nil
    }
    
    private func checkIfInParking(location: CLLocationCoordinate2D) {
        for parking in self.parking {
            let polygonRenderer = MKPolygonRenderer(polygon: MKPolygon(coordinates: parking.locations.map({ $0.getCLLocationCoordinate2D() }),
                                                    count: parking.locations.count))
            let mapPoint: MKMapPoint = MKMapPoint(location)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
            
            if polygonRenderer.path.contains(polygonViewPoint) {
                self.polygonRenderer = polygonRenderer
                self.currentParking = parking
                self.delegate?.waitingManager(self, didEnterTo: parking)
                self.startTime()
                break
            }
        }
    }
    
    private func startTime() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
            if self.currentParking != nil {
                self.startDate = Date()
            }
        }
    }
}
