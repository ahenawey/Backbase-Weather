//
//  WeatherDetailsViewController.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit

protocol WeatherDetailsDataStore
{
    var selectedCity: City! { get set }
}

protocol WeatherDetailsDisplayLogic: class
{
    var presenter: WeatherDetailsBusinessLogic? { get set }
    func displayWeatherForecast(forecast: Forecast)
    func displayError(error: Swift.Error)
}

class WeatherDetailsViewController: UITableViewController, WeatherDetailsDisplayLogic, WeatherDetailsDataStore
{
    
    var presenter: WeatherDetailsBusinessLogic?
    var selectedCity: City!
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let weatherDetailsPresenter = WeatherDetailsPresenter()
        weatherDetailsPresenter.viewController = self
        presenter = weatherDetailsPresenter
    }
    
    
    // MARK: View lifecycle
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadForecastForSelectedCity()
    }
    
    // MARK: Do something
    
    func loadForecastForSelectedCity()
    {
        presenter?.loadForecast(selectedCity: selectedCity)
        title = selectedCity.name
    }
    
    func displayWeatherForecast(forecast: Forecast)
    {
        
        // formatting info
        // https://openweathermap.org/weather-data
        let isMetricSystem = Locale.current.usesMetricSystem
        
        let temperatureUnit = isMetricSystem ? "°C" : "°F"
        let temperature: String = "\(Int(forecast.temperature)) \(temperatureUnit)"
        temperatureLabel.text = temperature
        
        let humidity: String = "\(Int(forecast.humidity)) %"
        humidityLabel.text = humidity
        
        var precipitation: String = "---"
        let precipitationUnit = isMetricSystem ? "mm" : "mm"
        if let _precipitation = forecast.precipitation {
            precipitation = "\(_precipitation) \(precipitationUnit)"
        }
        precipitationLabel.text = precipitation
        
        let windSpeedUnit = isMetricSystem ? "meter/sec" : "miles/hour"
        let windSpeed: String = "\(forecast.wind.speed) \(windSpeedUnit)"
        windSpeedLabel.text = windSpeed
        
        let windDegreesUnit = isMetricSystem ? "degrees" : "degrees"
        let windDegrees: String = "\(forecast.wind.speed) \(windDegreesUnit)"
        windDegreesLabel.text = windDegrees
    }
    
    func displayError(error: Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
