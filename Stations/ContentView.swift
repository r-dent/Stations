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

        return Resource(endpoint: StationService.findStations(nearby: location)!)
    }()

    var body: some View {
        NavigationView {
            MasterView(stations: stations)
                .navigationBarTitle(Text("Master"))
            DetailView()
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
    var station: Station?

    var body: some View {
        Group {
            if station != nil {
                Text(station!.name)
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
