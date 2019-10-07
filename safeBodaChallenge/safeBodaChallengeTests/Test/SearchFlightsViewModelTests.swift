//
//  SearchFlightsViewModelTests.swift
//  safeBodaChallengeTests
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import XCTest
@testable import safeBodaChallenge

class SearchFlightsViewModelTests: XCTestCase {

    let searchFlightsViewModelDelegateMock = SearchFlightsViewModelDelegateMock()
    var sut : SearchFlightsViewModel!
    
    override func setUp() {
        sut = SearchFlightsViewModel(delegate: searchFlightsViewModelDelegateMock)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testProcessAirportsResponse(){
       
        let expectation = self.expectation(description: "List of airports successfully processed")
        
        searchFlightsViewModelDelegateMock.didSetAirpots = { airports in
            expectation.fulfill()
            XCTAssert(airports.count > 0)
        }
        
        sut.processAirportsResponse(data: airportResponseMock)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
