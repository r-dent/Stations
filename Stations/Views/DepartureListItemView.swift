//
//  DepartureListItemView.swift
//  Stations
//
//  Created by Roman Gille on 12.07.20.
//  Copyright © 2020 Roman Gille. All rights reserved.
//

import SwiftUI

struct DepartureListItemView: View {

    @State var departure: Departure

    var body: some View {
        HStack {
            Text(departure.fpTime)
            Text(departure.prod)
            Text(departure.dir)
        }
    }
}

// MARK: - Preview

struct DepartureListItemView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            List {
                ForEach(PreviewData.departures) { departure in
                    DepartureListItemView(departure: departure)
                }
            }
            List {
                ForEach(PreviewData.departures) { departure in
                    DepartureListItemView(departure: departure)
                }
            }
            .preferredColorScheme(.dark)
        }

    }
}
