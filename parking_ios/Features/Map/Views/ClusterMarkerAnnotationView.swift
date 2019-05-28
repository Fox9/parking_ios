//
//  ClusterMarkerAnnotationView.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit
import MapKit

class ClusterMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = UIColor.blue
        }
    }
}
