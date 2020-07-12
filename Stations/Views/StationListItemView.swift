//
//  StationListItem.swift
//  Stations
//
//  Created by Roman Gille on 12.07.20.
//  Copyright © 2020 Roman Gille. All rights reserved.
//

import SwiftUI

struct StationListItemView: View {

    @State var station: Station

    var body: some View {

        NavigationLink(
            destination: DeparturesView(station: station)
        ) {
            VStack(alignment: .leading) {
                Text(station.name)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Image(systemName: "location")
                    Text(station.dist + "m")

                }
                .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(.blue)
        )


    }

}

// MARK: - Preview

struct StationListItemView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            List {
                ForEach(PreviewData.stations.prefix(3)) { station in
                    StationListItemView(station: station)
                }
            }
            List {
                ForEach(PreviewData.stations) { station in
                    StationListItemView(station: station)
                }
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)

    }
}
