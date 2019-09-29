//
//  SearchFlightsViewController.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 9/28/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import UIKit

class SearchFlightsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var testInputTxt: UITextField!
    
    //MARK: - Variables
    var networkManager : NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(delegate: self)        
    }

    //MARK: - Actions
    
    @IBAction func testAirportsRequest(_ sender: Any) {
        let testTxt = testInputTxt.text
        networkManager.requestAirports(testTxt)
    }
    
}

// This will be moved to the respective viewModel
extension SearchFlightsViewController : NetworkDelegate{
    func didRetrieveAirports(_ data: AirportResponse) {
        print("success")
    }
    
    func didRetrieveSchedules() {
        print("success")
    }
    
    func didFailWithError(_ error: Error) {
        print("failed")
    }
    
    
}
