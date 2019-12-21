//
//  ContentView.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import SwiftUI
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {

    var body: some View {
        NavigationView {
            MasterView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @ObservedObject var controller = StationController()

    var body: some View {
        view(for: controller.state).navigationBarTitle("Stations")
    }

    var locationPermissionButton: some View {
        Button(action: { self.controller.location.askForPermission() }) {
            Text("Enable location")
        }
    }

    func list(with stations: [Station]) -> some View {
        List {
            ForEach(stations) { station in
                NavigationLink(
                    destination: DetailView(station: station)
                ) {
                    Text(station.name)
                }
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

struct DetailView: View {

    let station: Station
    @ObservedObject private var departures: Resource<[Departure]>

    init(station: Station) {
        self.station = station
        self.departures = Resource(endpoint: try! StationService.fetchTimetable(for: station))
    }

    var body: some View {
        List {
            ForEach(departures.value ?? []) { departure in
                HStack {
                    Text(departure.fpTime)
                    Text(departure.prod)
                    Text(departure.dir)
                }
            }
        }.navigationBarTitle(Text(station.name))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
