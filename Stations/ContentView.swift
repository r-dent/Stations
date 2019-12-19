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

    @ObservedObject var location = Location()

    var body: some View {
        NavigationView {
            if !location.authorized {
                Button(action: { self.location.askForPermission() }) {
                    Text("Enable location")
                }
            } else if location.value == nil {
                Text("Searching location...")
                    .onAppear { self.location.start() }
            } else {
                MasterView(stations:
                    Resource(endpoint: try! StationService.findStations(nearby: location.value!))
                )
            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @ObservedObject var stations: Resource<[Station]>

    var body: some View {
        List {
            ForEach(stations.value ?? []) { station in
                NavigationLink(
                    destination: DetailView(station: station)
                ) {
                    Text(station.name)
                }
            }
        }.navigationBarTitle("Stations")
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
