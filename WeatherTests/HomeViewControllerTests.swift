//
//  HomeViewControllerTests.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

@testable import Weather
import XCTest
import CoreLocation

class HomeViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: HomeViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupHomeViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupHomeViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class HomeBusinessLogicSpy: HomeBusinessLogic
    {

        var loadBookmarkedLocationsCalled = false
        
        func loadBookmarkedLocations() {
            loadBookmarkedLocationsCalled = true
        }
        
        func deleteBookmarkedLocation(cityID: String?) {}
    }
    
    class TableViewSpy: UITableView {
        var deletedIndexPath: IndexPath?
        override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
            deletedIndexPath = indexPaths.first
        }
    }
    
    // MARK: Tests
    
    func testShouldloadBookmarkedLocationsWhenViewIsLoaded()
    {
        // Given
        let spy = HomeBusinessLogicSpy()
        sut.presenter = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.loadBookmarkedLocationsCalled, "viewDidLoad() should ask the interactor to load bookmarked locations")
    }
    
    func testDisplayCityDeleted()
    {
        // Given
        let spy = HomeBusinessLogicSpy()
        sut.presenter = spy
        sut.cities = [City(name: "Test", coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0))]
        
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        
        // When
        loadView()
        let tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        sut.displayCityDeleted(cityIndex: 0, cityIndexPath: deletedIndexPath)
        
        // Then
        XCTAssertEqual(tableViewSpy.deletedIndexPath, deletedIndexPath, "testDisplayCityDeleted(viewModel:) should call deleteRows(at indexPaths: , with animation: ) ")
    }
}
