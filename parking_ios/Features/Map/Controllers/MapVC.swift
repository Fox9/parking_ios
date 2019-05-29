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
    
    // MARK: - CONSTANTS
    private lazy var MAX_TOP_CONTRAINT = self.view.frame.height * 0.75
    private lazy var MIN_TOP_CONTRAINT = self.view.frame.height * 0.25
    
    // MARK: - IBOutlet
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
    
    // MARK: - Properies
    var viewModel: MapVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.delegate = self
            viewModel.loadParking()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        LocationManager.shared.delegate = self
        LocationManager.shared.start()
        
        self.viewModel = MapVM()
    }
    
    // MARK: - IBAction
    @IBAction func showHistory(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: Constants.HISTORY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "HistoryTVC") as! HistoryTVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - MKMapView Delegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyRender = MKPolygonRenderer(overlay: overlay)
        polyRender.strokeColor = UIColor.red
        polyRender.lineWidth = 4
        return polyRender
    }
}
// MARK: - LocationManager Delegate
extension MapVC: LocationManagerDelegate {
    func locationManager(_ class: LocationManager, didChangeLocation location: CLLocation) {
        WaitingManager.shared.changeLocation(currnetLocation: location.coordinate)
    }
    
    func locationManager(_ manager: LocationManager, didGetCurrent location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - WaitingManager Delegate
extension MapVC: WaitingManagerDelegate {
    
    func waitingManager(_ manager: WaitingManager, didLeaveFrom parking: Parking, startDate: Date, endDate: Date) {
        DispatchQueue.main.async {
            self.viewModel!.save(parking: parking, startDate: startDate, endDate: endDate)
            let seconds = Int(endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            self.showAlert(message: "Your parking time is \(seconds / 60) minutes and \(seconds % 60) seconds")
        }
    }
    
    func waitingManager(_ manager: WaitingManager, didEnterTo parking: Parking) {
        DispatchQueue.main.async {
            self.showAlert(message: "You entered the parking zone \(parking.name)")
        }
    }
    
    func waitingManager(_ manager: WaitingManager, didStart time: Date) {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        DispatchQueue.main.async {
            self.showAlert(message: "The time began from \(format.string(from: time))")
        }
    }
}

// MARK: - UITableView Delegate
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

// MARK: - UITableView DataSource
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

// MARK: - ViewModel Delegate
extension MapVC: MapVMDelegate {
    func mapVM(_ class: MapVM, didReceiveError message: String) {
        self.showAlert(message: message)
    }
    
    func mapVM(_ class: MapVM, didLoad parking: [Parking]) {
        self.mapView.addAnnotations(parking)
        self.produceOverlay(for: parking)
        self.mapView.reloadInputViews()
        
        self.parkingTableView.isHidden = false
        self.parkingTableView.reloadData()
        
        WaitingManager.shared.add(parking: parking)
        WaitingManager.shared.delegate = self
        if let currentLocation = LocationManager.shared.getCurrentLocation() {
            WaitingManager.shared.changeLocation(currnetLocation: currentLocation.coordinate)
        }
    }
    
    private func produceOverlay(for parking: [Parking]) {
        parking.forEach { parking in
            let coordinates = parking.locations.map({ $0.getCLLocationCoordinate2D() })
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polygon)
        }
    }
}
