//
//  SearchFlightsViewModel.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/3/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

protocol SearchFlightsViewModelDelegate: class {
    func setAirports(airports : [AirportObj])
    func setSchedules()
    func presentErrorMessage(error : Error)
}

class SearchFlightsViewModel : NSObject {
    private weak var delegate : SearchFlightsViewModelDelegate?
    var networkManager : NetworkManager!
    
    init(delegate : SearchFlightsViewModelDelegate){
        super.init()
        self.delegate = delegate
        networkManager = NetworkManager(delegate: self)
    }
    
    func requestAirports( ){
        networkManager.requestAirports()
    }
    
    func processAirportsResponse(data: AirportResponse){
        var airports : [AirportObj] = []
        
        switch data.AirportResource.Airports.Airport {
        case .array(let array):
            airports = array
        case .object(let string):
            airports.append(string)
        }
        
        delegate?.setAirports(airports : airports)
    }
    
}

extension SearchFlightsViewModel : NetworkDelegate {
    
    func didRetrieveAirports(_ data: AirportResponse) {
        processAirportsResponse(data: data)
    }
    
    func didRetrieveSchedules(_ data: Schedules) {
        // do something
    }
    
    func didFailWithError(_ error: Error) {
        delegate?.presentErrorMessage(error: error)
    }    
    
}


