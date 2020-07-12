//
//  DeparturesView.swift
//  Stations
//
//  Created by Roman Gille on 12.07.20.
//  Copyright © 2020 Roman Gille. All rights reserved.
//

import SwiftUI

struct DeparturesView: View {

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
                        DepartureListItemView(departure: departure)
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
