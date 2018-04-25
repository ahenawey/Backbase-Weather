//
//  HomeServiceTests.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//

@testable import Weather
import XCTest
import CoreLocation

class HomeServiceTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: HomeService!
    var mockDataSource: MockCityDataSource!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupHomeService()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupHomeService()
    {
        mockDataSource = MockCityDataSource()
        sut = HomeService(dataSource: mockDataSource)
    }
    
    // MARK: Test doubles
    class MockCityDataSource: CitiesStoreProtocol, CitiesStoreUtilityProtocol {
        
        var fetchIsCalled: Bool = false
        var deleteIsCalled: Bool = false
        var clearCitiesIsCalled: Bool = false
        
        func fetch(completionHandler: @escaping (Result<[City], CitiesStoreError>) -> ()) {
            fetchIsCalled = true
            completionHandler(.success([City]()))
        }
        
        func create(city: City, completionHandler: @escaping (Result<City, CitiesStoreError>) -> ()) {
        }
        
        func delete(id: String, completionHandler: @escaping (Result<City, CitiesStoreError>) -> ()) {
            deleteIsCalled = true
            completionHandler(.success(City(name: "Test", coordinates: CLLocationCoordinate2D(latitude: 123, longitude: 123))))
        }
        
        func clearCities(completionHandler: @escaping (Result<Void, CitiesStoreError>) -> ()) {
            clearCitiesIsCalled = true
            completionHandler(.success(()))
        }
        
    }
    // MARK: Tests
    
    func testRemoveAllCities()
    {
        // Given
        let expect = expectation(description: "Wait Until delete")
        // When
        sut.removeAllCities { _ in
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 1)
        // Then
        assert(mockDataSource.clearCitiesIsCalled, "All Cities did not removed as expected")
    }
    
    func testRemoveCity()
    {
        // Given
        let expect = expectation(description: "Wait Until delete")
        // When
        sut.removeCity(id: "1") { _ in
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
        // Then
        assert(mockDataSource.deleteIsCalled, "City did not removed as expected")
        
    }
    
    func testLoadCitiesAfterAdding()
    {
        // Given
        let expect = expectation(description: "Wait Until delete")
        // When
        sut.getCities { _ in
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
        // Then
        assert(mockDataSource.fetchIsCalled, "City did not added as expected")
    }
    
    
}
