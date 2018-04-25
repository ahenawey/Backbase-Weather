//
//  MobileAPIWeatherStore.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

class MobileAPIWeatherStore: WeatherStoreProtocol {
    
    fileprivate func generateURL(coordinate: CLLocationCoordinate2D, useMeteric: Bool) -> URL? {
        let unitsFormat = useMeteric ? "metric" : "imperial"
        
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=8a7a24723134e7bcb3d82e58e6489ba3&units=\(unitsFormat)")
    }
    
    fileprivate func parse(_ data: Data) throws -> Forecast{
            let forecast = try JSONDecoder().decode(Forecast.self, from: data)
            return forecast
    }
    
    
    func fetch(coordinate: CLLocationCoordinate2D,
               useMeteric: Bool,
               completionHandler: @escaping (Result<Forecast, WeatherStoreError>) -> ()) {
        
        guard let url = generateURL(coordinate: coordinate, useMeteric: useMeteric) else {
            completionHandler(.failure(.cannotFetch("URL formated wrong")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                completionHandler(.failure(.error(error)))
                return
            }
            
            guard let data = data,
                let storngSelf = self else {
                completionHandler(.failure(.cannotFetch("empty respose")))
                return
            }
            
            do{
                let forecast = try storngSelf.parse(data)
                completionHandler(.success(forecast))
            }catch (let error) {
                completionHandler(.failure(.error(error)))
            }
        }.resume()
    }
}
