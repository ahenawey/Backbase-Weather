//
//  WeatherDetailsService.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsService
{
    fileprivate let dataSource: WeatherStoreProtocol
    
    init(dataSource: WeatherStoreProtocol) {
        self.dataSource = dataSource
    }
    
    func getWeatherForcast(for coordinate: CLLocationCoordinate2D, useMeteric: Bool, completionHandler: @escaping (Result<Forecast, WeatherStoreError>) -> ()) {
        dataSource.fetch(coordinate: coordinate, useMeteric: useMeteric, completionHandler: completionHandler)
    }
}
