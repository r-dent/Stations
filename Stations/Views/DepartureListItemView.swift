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
            ZStack {
                Circle().foregroundColor(.yellow)
                Text(departure.product.icon)
            }
            .font(.caption)
            .frame(width: 28, height: 28, alignment: .center)
            Text(departure.lineNumber)
            Text(departure.dir)
        }
    }
}

// MARK: - Product mapping

extension Departure.Product {

    var icon: String {
        switch self {
        case .bus: return "🚍"
        case .train: return "🚆"
        case .tram: return "🚊"
        case .suburban: return "🚉"
        }
    }
}

// MARK: - Preview

struct DepartureListItemView_Previews: PreviewProvider {

    static var previews: some View {
        
        Group {
            ForEach(PreviewData.departures.prefix(3)) { departure in
                DepartureListItemView(departure: departure)
                    .frame(width: 320)
            }
            ForEach(PreviewData.departures.prefix(3)) { departure in
                DepartureListItemView(departure: departure)
                    .frame(width: 320)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)

    }
}
