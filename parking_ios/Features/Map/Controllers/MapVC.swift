//
//  MapVC.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/27/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit
import MapKit

class MapVC: BaseVC {
    
    override var isNavigationBarHidden: Bool {
        return true
    }

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
            mapView.register(ParkingMarkerAnnatationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            mapView.register(ClusterMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

        }
    }
    
    var viewModel: MapVM! {
        didSet {
            self.viewModel.delegate = self
            self.viewModel.loadParking()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
        LocationManager.shared.start()
        
        self.viewModel = MapVM()
    }
}

extension MapVC: LocationManagerDelegate {
    func locationManager(_ class: LocationManager, didChangeLocation location: CLLocation) {
        
    }
    
    func locationManager(_ manager: LocationManager, didGetCurrent location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}

extension MapVC: MKMapViewDelegate {
    
}

extension MapVC: MapVMDelegate {
    func mapVM(_ class: MapVM, didReceiveError message: String) {
        self.showAlert(message: message)
    }
    
    func mapVM(_ class: MapVM, didLoad parking: [Parking]) {
        self.mapView.addAnnotations(parking)
        self.mapView.reloadInputViews()
    }
}
