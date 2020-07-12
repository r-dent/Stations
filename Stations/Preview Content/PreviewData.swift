//
//  PreviewData.swift
//  Stations
//
//  Created by Roman Gille on 12.07.20.
//  Copyright © 2020 Roman Gille. All rights reserved.
//


import Foundation

/// Get JSON string in console:
/// `po NSString(data: JSONEncoder().encode(OBJECT), encoding: String.Encoding.utf8.rawValue)`
enum PreviewData {

    static let stations: [Station] = {

        let url = Bundle.main.url(forResource: "PreviewStations", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Station].self, from: data)
    }()

    static let departures: [Departure] = {

        let url = Bundle.main.url(forResource: "PreviewDepartures", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Departure].self, from: data)
    }()
}
