//
//  WeatherDetailsModels.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import CoreLocation


struct Wind: Decodable{
    var speed: Double
    var degrees: Int
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degrees = "deg"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decode(Double.self, forKey: .speed)
        degrees = try values.decode(Int.self, forKey: .degrees)
    }
}

struct Forecast: Decodable {
    
    var temperature: Double
    var pressure: Int
    var humidity: Int
    var wind: Wind
    fileprivate var rain: Dictionary<String, Int>?
    var precipitation: Int?
    
    enum CodingKeys: String, CodingKey {
        enum weatherInfo: String, CodingKey {
            case temperature = "temp"
            case pressure
            case humidity
        }
        
        case info = "main"
        case wind = "wind"
        case rain = "rain"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let weatherInfo = try values.nestedContainer(keyedBy: CodingKeys.weatherInfo.self, forKey: .info)
        temperature = try weatherInfo.decode(Double.self, forKey: .temperature)
        pressure = try weatherInfo.decode(Int.self, forKey: .pressure)
        humidity = try weatherInfo.decode(Int.self, forKey: .humidity)
        
        wind = try values.decode(Wind.self, forKey: .wind)
        do {
            rain = try values.decode(Dictionary<String, Int>?.self, forKey: .rain)
            precipitation = rain?.values.first
        } catch {}
    }
}
