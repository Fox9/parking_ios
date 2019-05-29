//
//  Parking.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation
import GLKit
import CoreLocation
import MapKit
import RealmSwift

class Parking: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var parkingDescription: String = ""
    @objc dynamic var image: String = ""
    var locations: [Location] = []
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func copy() -> Any {
        let parking = Parking()
        parking.id = self.id
        parking.name = self.name
        parking.parkingDescription = self.description
        parking.image = image
        parking.locations = self.locations
        return parking
    }
}

extension Parking: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return self.getCenter()
        }
    }
    var title: String? {
        get {
            return self.name
        }
    }
    
    private func getCenter() -> CLLocationCoordinate2D {
        var x: Float = 0.0;
        var y: Float = 0.0;
        var z: Float = 0.0;
        for location in self.locations {
            let lat = GLKMathDegreesToRadians(Float(location.latitude));
            let long = GLKMathDegreesToRadians(Float(location.longitude));
            
            x += cos(lat) * cos(long);
            
            y += cos(lat) * sin(long);
            
            z += sin(lat);
        }
        x = x / Float(self.locations.count);
        y = y / Float(self.locations.count);
        z = z / Float(self.locations.count);
        let resultLong = atan2(y, x);
        let resultHyp = sqrt(x * x + y * y);
        let resultLat = atan2(z, resultHyp);
        let result = CLLocationCoordinate2D(latitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLat))), longitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLong))));
        return result;
    }
}
