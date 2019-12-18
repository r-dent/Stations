//
//  StationResult.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation

struct StationResult: Codable {
    let prods: String
    let stops: [Station]
    let error: String
    let numberofstops: String
}
