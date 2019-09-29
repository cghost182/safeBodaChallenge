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
    func didRetrieveSchedules()
    func didFailWithError(_ error: Error)
}

class NetworkManager {
    private let token = "n3qsrpf7pp2tn3tv4rexu5k9"
    private var delegate : NetworkDelegate?
    private let airportsURL = "https://api.lufthansa.com/v1/mds-references/airports/%@?limit=4&offset=0&LHoperated=0"
    
    
    init (delegate : NetworkDelegate) {
        self.delegate = delegate
    }
    
    /**
     Performs the request to retrieve the airports list.
     - parameter airportCode: The 3 digits Airport code. If nil, the first 4 records will be returned
    */
    func requestAirports(_ airportCode : String? = ""){
        if let url = URL(string : String(format: airportsURL, airportCode!)) {
            runDataTaskForRequest(url) { [weak self] data in
                self?.handleAirportsResponse(data: data)
            }
        }
    }
    
    //MARK: - Private methods
    
    /**
     Attempts to parse the retrieved data into an `Airport` array and notifies via delegate.
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
     Helper method to run requests. Notifies on failure via delegate.
     - parameter url: The `URL` to perform the data task.
     - parameter completionBlock: A block to call when the request is successful and data has been retrieved.
     */
    private func runDataTaskForRequest(_ url: URL, completionBlock: @escaping (Data) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
