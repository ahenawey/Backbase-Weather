//
//  HomeModels.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

struct City: Codable, Equatable {
    var id: String?
    let name: String
    let coordinates: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case name
    }
    
    init(name: String,coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        
        id = try values.decode(String?.self, forKey: .id)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinates.latitude, forKey: .latitude)
        try container.encode(coordinates.longitude, forKey: .longitude)
        try container.encode(name, forKey: .name)
    }
    
    public static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.coordinates.latitude == rhs.coordinates.latitude &&
            lhs.coordinates.longitude == rhs.coordinates.longitude
    }
}


enum ValidationError: LocalizedError {
    case selectedCityInvalid
    
    var errorDescription: String? {
        switch self {
        case .selectedCityInvalid:
            return "Selected City Invalid"
        }
    }
}
