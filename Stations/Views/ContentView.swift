//
//  ContentView.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    var body: some View {
        NavigationView {
            StationsView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
