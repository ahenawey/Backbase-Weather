
//  AddNewLocationInteractor.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddNewLocationDelegate {
    func didAddNewCity(city: City)
}

protocol AddNewLocationBusinessLogic
{
    var delegate: AddNewLocationDelegate? { get set }
    
    func getCityName(coordinate: CLLocationCoordinate2D)
    func addCity(cityName: String?, cityCoordinate: CLLocationCoordinate2D?)
}

class AddNewLocationPresenter: AddNewLocationBusinessLogic
{
    var viewController: AddNewLocationDisplayLogic?
    var service: AddNewLocationService
    var delegate: AddNewLocationDelegate?
    
    init() {
        service = AddNewLocationService(dataSource: UserDefaultCitiesDataStore())
    }
    
    // MARK: Add City
    
    func getCityName(coordinate: CLLocationCoordinate2D)
    {
        let geoCoder = CLGeocoder()
        let mapLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(mapLocation, completionHandler: { [weak self] (placemarks, error) -> Void in
            
            if let error = error {
                self?.viewController?.displayError(error: error)
                return
            }
            
            // Place details
            guard let placeMark = placemarks?.first else {
                self?.viewController?.displayError(error: GeoCoderError.cannotGetCityName)
                return
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                self?.viewController?.displayCityName(cityName: city)
            } else {
                self?.viewController?.displayCityName(cityName: "Unknown City")
            }
        })
    }
    
    func addCity(cityName: String?, cityCoordinate: CLLocationCoordinate2D?) {
        
        guard let cityName = cityName,
            let coordinates = cityCoordinate else{
                viewController?.displayError(error: CitiesStoreError.cannotCreate("City invalid"))
                return
        }
        
        let city = City(name: cityName, coordinates: coordinates)
        service.addCity(city: city, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let city):
                self?.delegate?.didAddNewCity(city: city)
                self?.viewController?.displayCityAdded()
            case .failure(let error): break
            self?.viewController?.displayError(error: error)
            }
        })
    }
}
