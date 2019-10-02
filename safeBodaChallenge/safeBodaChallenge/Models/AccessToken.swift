//
//  AccessToken.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/1/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

struct AccessToken : Codable {
    let success : Bool
    let result : Result
}

struct Result : Codable {
    let token_type : String
    let expires_in : Double
    let access_token : String
}
