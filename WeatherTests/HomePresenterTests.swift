//
//  HomeInteractorTests.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

@testable import Weather
import XCTest

class HomePresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: HomePresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupHomePresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupHomePresenter()
  {
    sut = HomePresenter()
  }
  
  // MARK: Test doubles
  
//  class HomeDisplayLogicSpy: HomeDisplayLogic
//  {
//    var displayBookmarkedLocationsCalled = false
//    func displayBookmarkedLocations(cities: [City]) {
//        displayBookmarkedLocationsCalled = true
//    }
//    func displayCityDeleted(cityIndex: Int, cityIndexPath: IndexPath) {}
//    func displayError(title: String, message: String) {}
//  }
    
    class CitiesDataSourceSpy: CitiesStoreProtocol {
        var fetchBookmarkedLocationsCalled = false
        func fetch(completionHandler: @escaping (Result<[City],CitiesStoreError>)->()) {
            fetchBookmarkedLocationsCalled = true
        }
        func create(city: City,
                    completionHandler: @escaping (Result<City,CitiesStoreError>)->()) {}
        func delete(id: String,
                    completionHandler: @escaping (Result<City,CitiesStoreError>)->()) {}
        func clearCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->()){}
    }
  
  // MARK: Tests
  
  func testLoadBookmarkedLocations()
  {
    // Given
    let citiesDataSourceSpy = CitiesDataSourceSpy()
    let homeService = HomeService(dataSource: citiesDataSourceSpy)
    sut.service = homeService
    
    // When
    sut.loadBookmarkedLocations()
    
    // Then
    XCTAssertTrue(citiesDataSourceSpy.fetchBookmarkedLocationsCalled, "Bookmarked Locations fetched")
  }
}
