//
//  NetworkManager.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 9/29/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func didRetrieveAirports(_ data : AirportResponse)
    func didRetrieveSchedules(_ data : Schedules)
    func didFailWithError(_ error: Error)
}

final class NetworkManager {
    private var token = "9arv7cvcc27wdn2xky9xekxm"
    private var delegate : NetworkDelegate?
    private let apiLufthansaHost = "api.lufthansa.com"
    private let developerLufthansaHost = "developer.lufthansa.com"
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        return urlComponents
    }
    
    init (delegate : NetworkDelegate) {
        self.delegate = delegate
    }
    
    /**
     Performs the request to retrieve the access token.
     */
    func requestAccessToken() {
        
        let parameters = [
            "apiId": "3166",
            "auth_flow" : "client_cred",
            "client_id" : "6823met54bt72w86berd6tu8",
            "client_secret" : "u5KZy6wGyT"
        ]
        
        runDataTaskForRequest(developerLufthansaHost, path : "io-docs/getoauth2accesstoken" , parameters: parameters){ [weak self] (data) in
            self?.handleAccessTokenResponse(data: data)
        }
        
    }
    
    /**
     Performs the request to retrieve the airports list.
     - parameter airportCode: The 3 digits Airport code. If nil, the first 4 records will be returned
     */
    func requestAirports(_ airportCode : String? = ""){
        
        let path = String(format: "v1/mds-references/airports/%@", airportCode!)
        let parameters = [
            "limit": "4",
            "offset" : "0",
            "LHoperated" : "0"
        ]
        
        runDataTaskForRequest(apiLufthansaHost, path: path, parameters: parameters){ [weak self] (data) in
            self?.handleAirportsResponse(data: data)
        }
    }
    
    /**
     Performs the request to retrieve the airports list.
     - parameter airportCode: The 3 digits Airport code. If nil, the first 4 records will be returned
     */
    func requestSchedules( originAirport : String, destinationAirport : String, flightDate : String){
        
        let path = String(format: "v1/operations/schedules/%@/%@/%@", originAirport, destinationAirport , flightDate)
        let parameters = [
            "directFlights": "0"
        ]
        
        runDataTaskForRequest(apiLufthansaHost, path: path, parameters: parameters){ [weak self] (data) in
            self?.handleSchedulesResponse(data: data)
        }
    }
    
    
    
    //MARK: - Private methods
    
    
    
    /**
     Attempts to parse the retrieved data into an `AccessToken` object and set the local token.
     - parameter data: The `Data` received from the request.
     */
    private func handleAccessTokenResponse(data: Data) {
        do {
            let accessToken = try JSONDecoder().decode(AccessToken.self, from: data)
            self.token =  accessToken.result.access_token
        } catch _ {
            self.token = ""
        }
    }
    
    /**
     Attempts to parse the retrieved data into an `Airport` object and notifies via delegate.
     - parameter data: The `Data` received from the request.
     */
    private func handleAirportsResponse(data: Data) {
        do {
            let airports = try JSONDecoder().decode(AirportResponse.self, from: data)
            delegate?.didRetrieveAirports(airports)
        } catch let error {
            delegate?.didFailWithError(error)
        }
    }
    
    /**
     Attempts to parse the retrieved data into an `Schedules` object and notifies via delegate.
     - parameter data: The `Data` received from the request.
     */
    private func handleSchedulesResponse(data: Data) {
        do {
            let schedules = try JSONDecoder().decode(Schedules.self, from: data)
            delegate?.didRetrieveSchedules(schedules)
        } catch let error {
            delegate?.didFailWithError(error)
        }
    }
    
    /**
     Helper method to run requests. Notifies on failure via delegate.
     - parameter url: The `URL` to perform the data task.
     - parameter completionBlock: A block to call when the request is successful and data has been retrieved.
     */
    private func runDataTaskForRequest(_ host : String, path: String,   parameters: [String: String], completionBlock: @escaping (Data) -> Void) {
        
        var urlComponents = self.urlComponents
        urlComponents.host = host
        urlComponents.path = "/\(path)"
        urlComponents.setQueryItems(with: parameters)
        
        guard let url = urlComponents.url else {
            self.delegate?.didFailWithError(NSError(domain: "Error getting url", code: 100, userInfo: nil))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            if let error = error {
                self?.delegate?.didFailWithError(error)
                return
            }
            
            if let data = data {
                completionBlock(data)
            }

        }.resume()
        
    }
}



