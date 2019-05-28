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
    func locationManager(_ manager: LocationManager, didChangeLocation location: CLLocation)
    func locationManager(_ manager: LocationManager, didGetCurrent location: CLLocation)
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    
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
    
    func getCurrentLocation() -> CLLocation? {
        return self.currentLocation
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
        if self.currentLocation == nil {
            self.currentLocation = locations.first
            self.delegate?.locationManager(self, didGetCurrent: self.currentLocation!)
        } else {
            guard let location = locations.first else { return }
            let distanceInMeters = self.currentLocation!.distance(from: location)
            print("Distance - \(distanceInMeters)")
            if self.currentLocation != location {
                self.currentLocation = location
                self.delegate?.locationManager(self, didChangeLocation: location)
            }
        }
    }
}
