//
//  HomeService.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit

class HomeService
{
    fileprivate let dataSource: CitiesStoreProtocol
    
    init(dataSource: CitiesStoreProtocol) {
        self.dataSource = dataSource
    }
    
    func removeCity(id: String,
                    completionHandler: @escaping (Result<City,CitiesStoreError>)->()) {
        dataSource.delete(id: id, completionHandler: completionHandler)
    }
    
    func removeAllCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->()) {
        dataSource.clearCities(completionHandler: completionHandler)
    }
    
    func getCities(completionHandler: @escaping (Result<[City],CitiesStoreError>)->()) {
        dataSource.fetch(completionHandler: completionHandler)
    }
    
}
