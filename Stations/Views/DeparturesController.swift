//
//  DeparturesController.swift
//  Stations
//
//  Created by Roman Gille on 21.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation
import Combine

class DeparturesController: ObservableObject {

    enum State {
        case
        loading,
        content(Result<[Departure], Error>)
    }

    let station: Station

    @Published private(set) var state: State

    init(station: Station) {
        self.station = station
        self.state = .loading
    }

    func load() {
        loadDepartures(for: station)
    }

    private func loadDepartures(for station: Station) {

        guard let endpoint = try? StationService.fetchTimetable(for: station) else {
            return
        }

        URLSession.shared.load(endpoint) { [weak self] result in
            DispatchQueue.main.async {
                self?.state = .content(result)
            }
        }
    }
}
