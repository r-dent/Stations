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

    @ObservedObject private var controller: DeparturesController

    init(station: Station) {
        self.controller = DeparturesController(station: station)
    }

    var body: some View {
        view(for: controller.state).navigationBarTitle(Text(controller.station.name))
    }


    func view(for state: DeparturesController.State) -> some View {

        switch state {
        case .content(let result):

            switch result {
            case .success(let departures):
                return AnyView(List {
                    ForEach(departures) { departure in
                        HStack {
                            Text(departure.fpTime)
                            Text(departure.prod)
                            Text(departure.dir)
                        }
                    }
                })

            case .failure(let error):
                return AnyView(Text(String(describing: error)))
            }

        case .loading:
            return AnyView(Text("Loading").onAppear { self.controller.load() })

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
