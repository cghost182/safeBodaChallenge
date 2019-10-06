//
//  Utils.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/5/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
import UIKit

typealias FlightCoordinate = ( Latitude : Double, Longitude :  Double )

public func presentAlertMessage(message : String, navigationController : UINavigationController){
    let errorAlert = UIAlertController(title: "Opps!", message: message, preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    navigationController.present(errorAlert, animated: true, completion: nil)
}
