//
//  MapVM.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import Foundation

protocol MapVMDelegate: class {
    func mapVM(_ class: MapVM, didLoad parking: [Parking])
    func mapVM(_ class: MapVM, didReceiveError message: String)
}

class MapVM {
    
    weak var delegate: MapVMDelegate?
    
    var parking = [Parking]()
    
    func loadParking() {
        DispatchQueue.global(qos: .utility).async {
            guard let parkingJSON = Bundle.main.path(forResource: "Parkings", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: parkingJSON)) else {
                    DispatchQueue.main.async {
                        self.delegate?.mapVM(self, didReceiveError: "Error when read file")
                    }
                    return
            }
            do {
                self.parking = try JSONDecoder().decode([Parking].self, from: data)
                sleep(1)
                DispatchQueue.main.async {
                    self.delegate?.mapVM(self, didLoad: self.parking)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.mapVM(self, didReceiveError: error.localizedDescription)
                }
            }
        }
    }
}
