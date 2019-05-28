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
    
    private lazy var MAX_TOP_CONTRAINT = self.view.frame.height * 0.75
    private lazy var MIN_TOP_CONTRAINT = self.view.frame.height * 0.25
    
    override var isNavigationBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var parkingTableView: UITableView! {
        didSet {
            parkingTableView.isHidden = true
            parkingTableView.delegate = self
            parkingTableView.dataSource = self
            parkingTableView.tableFooterView = UIView(frame: .zero)
            parkingTableView.register(ParkingTVCell.nib, forCellReuseIdentifier: ParkingTVCell.identifier)
        }
    }
    @IBOutlet weak var parkingTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
            mapView.register(ParkingMarkerAnnatationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            mapView.register(ClusterMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

        }
    }
    
    var viewModel: MapVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.delegate = self
            viewModel.loadParking()
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

extension MapVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let parking = self.viewModel!.parking[indexPath.row]
        let region = MKCoordinateRegion(center: parking.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
        self.changeParkingTableView(isHide: true)
        mapView.setRegion(region, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var constant = self.parkingTableViewTopConstraint.constant - scrollView.contentOffset.y
        if constant > self.MAX_TOP_CONTRAINT {
            constant = self.MAX_TOP_CONTRAINT
        } else if constant < self.MIN_TOP_CONTRAINT {
            constant = self.MIN_TOP_CONTRAINT
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        self.parkingTableViewTopConstraint.constant = constant
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.finishScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.finishScrolling()
    }
    
    private func finishScrolling() {
        if self.parkingTableViewTopConstraint.constant > self.MAX_TOP_CONTRAINT / 2 {
            self.changeParkingTableView(isHide: true)
        } else {
            self.changeParkingTableView(isHide: false)
        }
        
    }
    
    private func changeParkingTableView(isHide: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.parkingTableViewTopConstraint.constant = isHide ? self.MAX_TOP_CONTRAINT: self.MIN_TOP_CONTRAINT
            self.view.layoutIfNeeded()
        })

    }
}

extension MapVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.parking.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParkingTVCell.identifier) as! ParkingTVCell
        cell.setup(self.viewModel!.parking[indexPath.row])
        return cell
    }
}

extension MapVC: MapVMDelegate {
    func mapVM(_ class: MapVM, didReceiveError message: String) {
        self.showAlert(message: message)
    }
    
    func mapVM(_ class: MapVM, didLoad parking: [Parking]) {
        self.mapView.addAnnotations(parking)
        self.mapView.reloadInputViews()
        
        self.parkingTableView.isHidden = false
        self.parkingTableView.reloadData()
    }
}
