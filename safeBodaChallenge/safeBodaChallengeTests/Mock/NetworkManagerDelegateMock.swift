//
//  NetworkManagerDelegateMock.swift
//  safeBodaChallengeTests
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
@testable import safeBodaChallenge

class NetworkManagerDelegateMock : NetworkDelegate{
    
    var didRetrieveAirports: ((AirportResponse) -> Void)?
    var didRetrieveSchedules : ((Schedules) -> Void)?
    
    func didRetrieveAirports(_ data: AirportResponse) {
        didRetrieveAirports?(data)
    }
    
    func didRetrieveSchedules(_ data: Schedules) {
        didRetrieveSchedules?(data)
    }
    
    func didFailWithError(_ error: Error) {
        
    }
    
    
}
