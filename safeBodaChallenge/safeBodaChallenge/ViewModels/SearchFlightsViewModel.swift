//
//  SearchFlightsViewModel.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/3/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

protocol SearchFlightsViewModelDelegate: class {
    func didSetAccessToken()
    func setAirports(airports : [AirportObj])
    func setSchedules(schedules : [Schedule])
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
    
    func requestAccessToken(){
        networkManager.requestAccessToken { [weak self] in
            self?.delegate?.didSetAccessToken()
        }
    }
    
    func requestAirports(){
        networkManager.requestAirports()
    }
    
    func requestAirport(airportCode : String){
        networkManager.requestAirports(airportCode)
    }
    
    func processAirportsResponse(data: AirportResponse){
        var airports : [AirportObj] = []
        
        switch data.AirportResource.Airports.Airport {
        case .array(let array):
            airports = array
        case .object(let airport):
            airports.append(airport)
        }
        
        delegate?.setAirports(airports : airports)
    }
    
    func requestSchedules(originAirport: String, destinationAirport: String, flightDate: String){
        networkManager.requestSchedules(originAirport: originAirport, destinationAirport: destinationAirport, flightDate: flightDate)
    }
    
}

extension SearchFlightsViewModel : NetworkDelegate {
    
    func didRetrieveAirports(_ data: AirportResponse) {
        processAirportsResponse(data: data)
    }
    
    func didRetrieveSchedules(_ data: Schedules) {
        delegate?.setSchedules(schedules: data.ScheduleResource.Schedule)
    }
    
    func didFailWithError(_ error: Error) {
        delegate?.presentErrorMessage(error: error)
    }    
    
}


