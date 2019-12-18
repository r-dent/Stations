//
//  Departure.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation

struct Departure: Codable {
    
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
