//
//  StationController.swift
//  Stations
//
//  Created by Roman Gille on 20.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Combine
import CoreLocation

class StationController: ObservableObject {

    enum State {
        case
        locationPermissionNeeded,
        locationPermissionForbidden,
        stations([Station]?)
    }

    let location = Location()
    private var lastLocation: CLLocation?
    var permissionUpdates: AnyCancellable?
    var locationUpdates: AnyCancellable?

    @Published private(set) var state: State

    init() {

        self.state = StationController.state(for: location.authorized)

        permissionUpdates = location.$authorized.sink() { [weak self] auth in
            self?.state = StationController.state(for: auth)
            if auth == true {
                self?.location.start()
            }
        }
        
        locationUpdates = location.$value.sink { [weak self] loc in
            if let location = loc {
                if self?.lastLocation == nil ||  self!.lastLocation!.distance(from: location) > 20 {
                    self?.lastLocation = location
                    self?.loadStations(for: location)
                }
            }
        }
    }

    static func state(for authorized: Bool?) -> State {

        if let authorized = authorized {
            return (authorized ? .stations(nil) : .locationPermissionForbidden)
        } else {
            return .locationPermissionNeeded
        }
    }

    func loadStations(for location: CLLocation) {

        guard let endpoint = try? StationService.findStations(nearby: location) else {
            return
        }

        URLSession.shared.load(endpoint) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stations):
                    self?.state = .stations(stations)

                case .failure(let error):
                    self?.state = .stations([])
                    print(String(describing: error))
                }
            }
        }
    }
}
