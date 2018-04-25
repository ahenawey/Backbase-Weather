//
//  CitiesStore.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import Foundation

protocol CitiesStoreProtocol {
    func fetch(completionHandler: @escaping (Result<[City],CitiesStoreError>)->())
    func create(city: City,
                     completionHandler: @escaping (Result<City,CitiesStoreError>)->())
    func delete(id: String,
                     completionHandler: @escaping (Result<City,CitiesStoreError>)->())
    func clearCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->())
}

protocol CitiesStoreUtilityProtocol {}

extension CitiesStoreUtilityProtocol
{
    func generateCityID(city: inout City)
    {
        guard city.id == nil else { return }
        city.id = "\(arc4random())"
    }
    
}

enum CitiesStoreError: Equatable, LocalizedError
{
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
    
    var errorDescription: String? {
        switch self {
        default:
            return "Cannot access data now, Please try again later!"
        }
    }
}

