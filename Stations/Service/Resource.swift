//
//  Resource.swift
//  Stations
//
//  Created by Roman Gille on 18.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation
import Combine

final class Resource<A>: ObservableObject {

    let endpoint: Endpoint<A>
    @Published var value: A?

    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            DispatchQueue.main.async {
                self.value = try? result.get()
            }
        }
    }
}
