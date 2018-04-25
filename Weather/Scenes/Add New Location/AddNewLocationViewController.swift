//
//  AddNewLocationViewController.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit
import MapKit

protocol AddNewLocationDisplayLogic: class
{
    var presenter: AddNewLocationBusinessLogic? {get set}
    func displayCityName(cityName: String)
    func displayCityAdded()
    func displayError(error: Error)
}

class AddNewLocationViewController: UIViewController, AddNewLocationDisplayLogic
{
    var presenter: AddNewLocationBusinessLogic?
    @IBOutlet weak var confrimButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityName: UILabel!
    
    var currentAnnotation: MKPointAnnotation? {
        didSet {
            let userSelectedAnnotation = currentAnnotation != nil
            confrimButton.isEnabled = userSelectedAnnotation
        }
    }
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
        let addNewLocationPresenter = AddNewLocationPresenter()
        addNewLocationPresenter.viewController = self
        presenter = addNewLocationPresenter
    }
    
    // MARK: View lifecycle
    
    
    @IBAction func handleUserLocationSelection(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        currentAnnotation = MKPointAnnotation()
        currentAnnotation!.coordinate = coordinate
        
        presenter?.getCityName(coordinate: coordinate)
    }
    
    @IBAction func ConfrimTouchUpInside(_ sender: Any) {
        presenter?.addCity(cityName: currentAnnotation?.title, cityCoordinate: currentAnnotation?.coordinate)
    }
    
    // MARK: Displaying
    
    func displayCityAdded() {
        navigationController?.popViewController(animated: true)
    }
    
    func displayCityName(cityName: String) {
        if let lastAnnotation = currentAnnotation {
            mapView.removeAnnotation(lastAnnotation)
        }
        
        // Add annotation:
        currentAnnotation?.title = cityName
        mapView.addAnnotation(currentAnnotation!)
        
        self.cityName.text = cityName
    }
    
    func displayError(error: Error){
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
