//
//  WeatherDetailsInteractor.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherDetailsBusinessLogic
{
    func loadForecast(selectedCity: City)
}

class WeatherDetailsPresenter: WeatherDetailsBusinessLogic
{
    var viewController: WeatherDetailsDisplayLogic?
    var service: WeatherDetailsService
    
    // MARK: Load business
    
    init() {
        service = WeatherDetailsService(dataSource: MobileAPIWeatherStore())
    }
    
    func loadForecast(selectedCity: City)
    {
        service.getWeatherForcast(for: selectedCity.coordinates, useMeteric: Locale.current.usesMetricSystem, completionHandler: { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self?.viewController?.displayWeatherForecast(forecast: forecast)
                case .failure(let error):
                    self?.viewController?.displayError(error: error)
                }
            }
        })
    }
    
}
