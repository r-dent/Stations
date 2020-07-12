//
//  Departure.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation

struct Departure: Codable {

    enum Product: String {
        case bus = "Bus"
        case tram = "STR"
        case suburban = "S"
        case train = "Bahn"

        static let `default`: Product = .train
    }
    
    let administration: String
    let approxDelay: String
    let delay: String
    let delayReason: String
    let dir: String
    let dirnr: String
    let fpDate: String
    let fpTime: String
    let is_reachable: String
    let prod: String
    let targetLoc: String
}

extension Departure: Identifiable {

    var id: String {
        return self.fpDate + self.fpTime + self.prod + self.targetLoc
    }
}

extension Departure {

    var lineNumber: String {
        String(
            prod.split(separator: "#").first?.split(separator: " ").last ?? ""
        )
    }

    var product: Product {
        
        guard let productIdentifier: String.SubSequence = prod.split(separator: "#").last else {
            return .default
        }
        return Product(rawValue: String(productIdentifier)) ?? .default
    }
}
