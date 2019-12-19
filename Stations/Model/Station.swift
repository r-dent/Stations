//
//  Station.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import CoreLocation

struct Station: Codable {
    
    let x: String
    let y: String
    let name: String
    let urlname: String
    let prodclass: String
    let extId: String
    let puic: String
    let dist: String
    let planId: String

    var coordinate: CLLocationCoordinate2D? {
        guard
            let lat: CLLocationDegrees = Double(self.x),
            let long: CLLocationDegrees = Double(self.y)
            else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

extension Station: Identifiable {
    var id: String {
        return self.extId
    }
}
