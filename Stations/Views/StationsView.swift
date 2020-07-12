//
//  StationsView.swift
//  Stations
//
//  Created by Roman Gille on 12.07.20.
//  Copyright © 2020 Roman Gille. All rights reserved.
//

import SwiftUI

struct StationsView: View {
    @ObservedObject var controller = StationController()

    var body: some View {
        view(for: controller.state)
            .navigationBarTitle("Stations")
            .onAppear { self.controller.startLocationMonitoring() }
            .onDisappear {self.controller.stopLocationMonitoring() }
    }

    var locationPermissionButton: some View {
        Button(action: { self.controller.location.askForPermission() }) {
            Text("Enable location")
        }
    }

    func list(with stations: [Station]) -> some View {
        List {
            ForEach(stations) { station in
                StationListItemView(station: station)
            }
        }
    }

    func view(for state: StationController.State) -> some View {

        switch state {
        case .locationPermissionNeeded:
            return AnyView(locationPermissionButton)
        case .locationPermissionForbidden:
            return AnyView(Text("No permission given."))

        case .stations(let stations):
            if let stations = stations {
                return AnyView(list(with: stations))
            } else {
                return AnyView(Text("Loading Stations..."))
            }
        }
    }
}
