//
//  HomePresenter.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 25/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func loadBookmarkedLocations()
    func deleteBookmarkedLocation(cityID: String?)
}

class HomePresenter: HomeBusinessLogic, AddNewLocationDelegate {
    var viewController: HomeDisplayLogic?
    var service: HomeService
    
    var cities: [City]!
        
    // MARK: Business Logic
    
    init() {
        service = HomeService(dataSource: UserDefaultCitiesDataStore())
    }
    
    func loadBookmarkedLocations()
    {
        service.getCities(completionHandler: { [weak self] (result) in
            switch result {
            case .success(let cities):
                self?.cities = cities
                
                self?.viewController?.displayBookmarkedLocations(cities: cities)
            case .failure(let error):
                self?.viewController?.displayError(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription)
            }
        })
    }
    func deleteBookmarkedLocation(cityID: String?) {
        guard let cityID = cityID else {
            let error = CitiesStoreError.cannotDelete("City id is invalid")
            viewController?.displayError(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription)
            return
        }
        
        service.removeCity(id: cityID, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let city):
                guard let storngSelf = self,
                    let viewController = storngSelf.viewController,
                    let deletedIndex = storngSelf.cities.index(where: {$0 == city}) else {
                        return
                }
                storngSelf.cities.remove(at: deletedIndex)
                
                let deletedIndexPath = IndexPath(row: deletedIndex, section: 0)
                viewController.displayCityDeleted(cityIndex: deletedIndex, cityIndexPath: deletedIndexPath)
            case .failure(let error):
                self?.viewController?.displayError(title: NSLocalizedString("Error", comment: "Error"), message: error.localizedDescription)
            }
        })
    }
    
    // MARK: Add New Location Delegate
    func didAddNewCity(city: City) {
        cities.append(city)
        viewController?.displayBookmarkedLocations(cities: cities)
    }
    
    
}
