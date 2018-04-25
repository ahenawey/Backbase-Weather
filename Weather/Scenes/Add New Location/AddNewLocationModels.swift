//
//  AddNewLocationModels.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import Foundation

enum GeoCoderError: LocalizedError {    
    case cannotGetCityName
    
    var errorDescription: String?{
        switch self {
        case .cannotGetCityName:
            return "Cannot get city name"
        }
    }
}
