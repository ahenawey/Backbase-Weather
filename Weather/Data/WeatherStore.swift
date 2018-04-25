//
//  WeatherStore.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherStoreProtocol {
    func fetch(coordinate: CLLocationCoordinate2D,
    useMeteric: Bool,
    completionHandler: @escaping (Result<Forecast, WeatherStoreError>) -> ())
}

enum WeatherStoreError: LocalizedError
{
    case cannotFetch(String)
    case error(Swift.Error)
    
    var errorDescription: String? {
        switch self {
        default:
            return "Cannot access data now, Please try again later!"
        }
    }
}
