//
//  SearchFlightsViewModelDelegateMock.swift
//  safeBodaChallengeTests
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
@testable import safeBodaChallenge

class SearchFlightsViewModelDelegateMock : SearchFlightsViewModelDelegate {
   
    var didSetAirpots : (([AirportObj]) -> Void)?
    var didSetSchedules : (([Schedule]) -> Void)?
    
    func setAirports(airports: [AirportObj]) {
        didSetAirpots?(airports)
    }
    
    func setSchedules(schedules: [Schedule]) {
        didSetSchedules?(schedules)
    }
    
    func presentErrorMessage(error: Error) {
        
    }
    
    func didSetAccessToken() {
        
    }
}
