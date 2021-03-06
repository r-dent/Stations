//
//  Location.swift
//  Stations
//
//  Created by Roman Gille on 19.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

final class Location: NSObject, ObservableObject {

    let manager: CLLocationManager
    private var lastLocationUpdate = Date()
    @Published var value: CLLocation?
    @Published var authorized: Bool?

    override init() {

        self.authorized = Location.authStatus(with: CLLocationManager.authorizationStatus())
        self.manager = CLLocationManager()
        super.init()

        manager.delegate = self
    }

    func askForPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func start() {
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }

    private static func authStatus(with status: CLAuthorizationStatus) -> Bool? {
        if status == .notDetermined {
            return nil
        }
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
}

extension Location: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let now = Date()
        if self.value == nil || (!locations.isEmpty && now.timeIntervalSince(lastLocationUpdate) > 5) {
            print("Location: " + String(describing: locations.first))
            self.value = locations.first
            self.lastLocationUpdate = now
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorized = Location.authStatus(with: status)
    }
}

