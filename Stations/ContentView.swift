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

    @ObservedObject private var stations: Resource<[Station]> = {

        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 51.334421, longitude: 12325947),
            altitude: 0,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            course: 0,
            speed: 0,
            timestamp: Date()
        )

        return Resource(endpoint: try! StationService.findStations(nearby: location))
    }()

    var body: some View {
        NavigationView {
            MasterView(stations: stations)
                .navigationBarTitle(Text("Master"))
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
                Text(departure.dir)
            }
        }.navigationBarTitle(Text(station.name))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
