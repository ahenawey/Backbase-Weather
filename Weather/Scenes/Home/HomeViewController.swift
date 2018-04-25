//
//  HomeViewController.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit

protocol HomeDataStore: class {
    var selectedCity: City? { get set }
}

protocol HomeDisplayLogic: class {
    var presenter: HomeBusinessLogic? { get set }
    func displayBookmarkedLocations(cities: [City])
    func displayCityDeleted(cityIndex: Int, cityIndexPath: IndexPath)
    func displayError(title: String, message: String)
}

class HomeViewController: UITableViewController, HomeDisplayLogic, HomeDataStore
{
    var delegate: AddNewLocationDelegate?
    var presenter: HomeBusinessLogic?
    
    // MARK: Object lifecycle
    var cities: [City]?
    var selectedCity: City?
    
    // MARK: View lifecycle
    
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
    
    func setup() {
        let homePresenter = HomePresenter()
        homePresenter.viewController = self
        presenter = homePresenter
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadBookmarkedLocations()
    }
    
    // MARK: Load Cities
    
    private func updateEmptyStateTextVisiabilty() {
        guard var footerFrame = tableView.tableFooterView?.frame else {
            return
        }
        
        let size = footerFrame.size
        
        if let cities = cities,
            cities.count > 0 {
            let newSize = CGSize(width: size.width, height: 0)
            footerFrame = CGRect(origin: footerFrame.origin,
                                 size: newSize)
        } else {
            let newSize = CGSize(width: size.width,
                                 height: 44)
            footerFrame = CGRect(origin: footerFrame.origin,
                                 size: newSize)
        }
        tableView.tableFooterView?.frame = footerFrame
    }
    
    func loadBookmarkedLocations() {
        presenter?.loadBookmarkedLocations()
    }
    
    func displayBookmarkedLocations(cities: [City]) {
        self.cities = cities
        updateEmptyStateTextVisiabilty()
        tableView.reloadData()
    }
    
    func displayCityDeleted(cityIndex: Int, cityIndexPath: IndexPath) {
        tableView.beginUpdates()
        if self.cities?.remove(at: cityIndex) != nil {
            tableView.deleteRows(at: [cityIndexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func displayError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Table delegate and datasource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            presenter?.deleteBookmarkedLocation(cityID: cities?[indexPath.row].id)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let city = cities?[indexPath.row]
        
        cell?.textLabel?.text = city?.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCity = cities?[indexPath.row]
        performSegue(withIdentifier: "Details", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewLocation" {
            guard
            let homeDisplayLogic = segue.source as? HomeDisplayLogic,
            let addNewLocationDelegate = homeDisplayLogic.presenter as? AddNewLocationDelegate,
            
            let addNewLocationDisplayLogic = segue.destination as? AddNewLocationDisplayLogic,
            var addNewLocationBusinessLogic = addNewLocationDisplayLogic.presenter else {
                return
            }
            
            addNewLocationBusinessLogic.delegate = addNewLocationDelegate
            
        } else if segue.identifier == "Details" {
            guard
                let homeDataStore = segue.source as? HomeDataStore,
                var weatherDetailsDataStore = segue.destination as? WeatherDetailsDataStore else {
                    return
            }
            
            weatherDetailsDataStore.selectedCity = homeDataStore.selectedCity
        }
    }
}
