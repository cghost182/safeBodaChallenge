//
//  Extensions.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/2/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}
