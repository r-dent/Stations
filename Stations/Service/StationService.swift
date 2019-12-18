//
//  StationService.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import CoreLocation

class StationService {

    let jsonDecoder: JSONDecoder

    init() {
        jsonDecoder = JSONDecoder()
    }

    func findStations(
        nearby location: CLLocation,
        range: CLLocationDistance = 100,
        limit: Int = 10,
        completion: @escaping (Result<[Station], Error>) -> Void
    ) {

        guard var components = URLComponents(string: "https://mobile.bahn.de/bin/query.exe/dny") else {
            completion(.failure(NSError()))
            return
        }

        let getString: (Double) -> String = {
            var string = NSNumber(floatLiteral: $0).description.replacingOccurrences(of: ".", with: "")
            string = NSString(string: "00000000").replacingCharacters(in: NSRange(location: 0, length: string.count), with: string)
            if($0 < 10){
                string = String(string.prefix(string.count))
            }
            return string
        }

        let parameters: [String: String] = [
            "performLocating": "2",
            "tpl": "stop2json",
            "look_maxdist": String(format: "%.0f", range * 10),
            "look_maxno": String(format: "%i", limit),
            "look_stopclass": "1023",
            "look_y": getString(location.coordinate.latitude),
            "look_x": getString(location.coordinate.longitude),
            "look_nv": "del_doppelt|yes"
        ]
        components.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            completion(.failure(NSError()))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, dataError) in

            guard let data = data, let cleanData = String(data: data, encoding: .isoLatin1)?.data(using: .utf8) else {
                completion(.failure(NSError()))
                return
            }

            do {
                let stations = try self?.jsonDecoder.decode(StationResult.self, from: cleanData).stops ?? []
                completion(.success(stations))
            } catch  {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchTimetable(
        for station: Station,
        starting: Date? = nil,
        limit: Int = 10,
        completion: @escaping (Result<[Departure], Error>) -> Void
    ) {

        guard var components = URLComponents(string: "https://reiseauskunft.bahn.de/bin/stboard.exe/dn") else {
            completion(.failure(NSError(domain: "url parsing", code: 0)))
            return
        }

        var parameters: [String: String] = [
            "productsFilter" : "100111111",
            "maxJourneys" : String(format: "%i", limit),
            "boardType" : "dep",
            "start" : "yes",
            "L" : "vs_java3",
            "_charset_" : "iso-8859-1",
            "disableEquivs" : "yes",
            "input" : station.extId
        ]
        components.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value) }

        if let starting = starting {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YY"
            parameters["startDate"] = formatter.string(from: starting)
            formatter.dateFormat = "HH:mm"
            parameters["time"] = formatter.string(from: starting)
        }

        guard let url = components.url else {
            completion(.failure(NSError(domain: "url composing", code: 0)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, dataError) in

            if let error = dataError {
                completion(.failure(error))
                return
            }

            guard
                let data = data,
                let xmlString = String(data: data, encoding: .isoLatin1),
                let utf8data = String(format: "<journeys>%@</journeys>", xmlString).data(using: .utf8),
                let xmlDoc = XMLTransform().document(with: utf8data)
                else {
                    completion(.failure(NSError(domain: "decoding", code: 0)))
                    return
            }

            let departures: [Departure] = xmlDoc.children.compactMap { try? Departure(from: $0.attributes) }

            completion(.success(departures))
        }
        task.resume()
    }
}

extension Decodable {

    init(from: Any) throws {

        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Self.self, from: data)
    }
}
