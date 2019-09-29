//
//  Airport.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 9/29/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation


struct AirportResponse : Codable {
    let AirportResource : AirportResource
    
    struct AirportResource : Codable {
        let Airports : Airports
    }
}


struct Airports : Codable {
    let Airport : Airport
}

enum Airport: Codable {
    case array([AirportObj])
    case object(AirportObj)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .array(container.decode(Array.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .object(container.decode(AirportObj.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(Airport.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let array):
            try container.encode(array)
        case .object(let string):
            try container.encode(string)
        }
    }
}


struct AirportObj : Codable{
    let AirportCode : String
    let Position : AirportPosition
    let CityCode : String
    let CountryCode : String

    enum CodingKeys : CodingKey {
        case AirportCode
        case Position
        case CityCode
        case CountryCode
    }

}

struct AirportPosition : Codable {
    let Coordinate : AirportCoordinate
}

struct AirportCoordinate : Codable {
    let Latitude : Double
    let Longitude : Double
}



