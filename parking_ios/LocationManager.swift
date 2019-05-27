//
//  LocationManager.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/27/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ class: LocationManager, didChangeLocation location: CLLocation)
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    private var lastLocation: CLLocation?
    
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
            return
        }
        self.startUpdateLocation()
    }
    
    func getLastLocation() -> CLLocation? {
        return self.lastLocation
    }
    
    private func startUpdateLocation() {
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            self.startUpdateLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.lastLocation == nil {
            self.lastLocation = locations.first
        } else {
            guard let location = locations.first else { return }
            let distanceInMeters = self.lastLocation!.distance(from: location)
            print("Distance - \(distanceInMeters)")
            if self.lastLocation != location {
                self.lastLocation = location
                self.delegate?.locationManager(self, didChangeLocation: location)
            }
        }
    }
}
