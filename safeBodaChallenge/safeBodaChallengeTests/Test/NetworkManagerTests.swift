//
//  NetworkManagerTests.swift
//  safeBodaChallengeTests
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import XCTest
@testable import safeBodaChallenge

class NetworkManagerTests: XCTestCase {
    
    let networkManagerDelegateMock = NetworkManagerDelegateMock()
    var sut : NetworkManager!

    override func setUp() {
        sut = NetworkManager(delegate: networkManagerDelegateMock)
    }

    override func tearDown() {
        sut = nil
    }

    func testRetrieveListOfAirports() {
       let expectation = self.expectation(description: "List of airports obtained")
        
        sut.requestAccessToken {
            self.networkManagerDelegateMock.didRetrieveAirports = { data in
                expectation.fulfill()
                let airportsArray = data.AirportResource.Airports.Airport
                
                switch airportsArray {
                case .array(let airports):
                        XCTAssertTrue(airports.count > 0, "List must not be empty")
                case .object( _):
                        XCTAssertTrue(true , "At least one airport retrieved")
                }
                
            }
            
            self.sut.requestAirports()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRetrieveSpecificAirport() {
        let airportCode = "TXL"
        let expectation = self.expectation(description: "\(airportCode) airport obtained")
        
        sut.requestAccessToken {
            self.networkManagerDelegateMock.didRetrieveAirports = { data in
                expectation.fulfill()
                let airportsArray = data.AirportResource.Airports.Airport
                
                switch airportsArray {
                case .array(let airports):
                    XCTAssertFalse(airports.count > 0, "Only one airport should be obtained")
                case .object( let airport):
                    XCTAssertEqual(airport.AirportCode, airportCode)
                }
                
            }
            
            self.sut.requestAirports(airportCode)
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRequestSchedules(){
        let expectation = self.expectation(description: "schedules obtained")
        
        sut.requestAccessToken {
            self.networkManagerDelegateMock.didRetrieveSchedules = { data in
                expectation.fulfill()
                XCTAssertTrue(data.ScheduleResource.Schedule.count > 0, "list of schedules must have at least one element")
            }
            
            self.sut.requestSchedules(originAirport: "TXL", destinationAirport: "BOG", flightDate: "2019-11-24")
        }
        waitForExpectations(timeout: 10, handler: nil)
    }


}
