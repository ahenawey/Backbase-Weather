//
//  AddNewLocationService.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

class AddNewLocationService
{
    fileprivate let dataSource: CitiesStoreProtocol
    
    init(dataSource: CitiesStoreProtocol) {
        self.dataSource = dataSource
    }
    
    func addCity(city: City,
                 completionHandler: @escaping (Result<City,CitiesStoreError>)->()) {
        if CLLocationCoordinate2DIsValid(city.coordinates) {
            dataSource.create(city: city, completionHandler: completionHandler)
        } else {
            completionHandler(.failure(CitiesStoreError.cannotCreate("Coordinates: \(city.coordinates) is not valid")))
        }
    }
}
