//
//  Schedules.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/1/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation

struct Schedules : Codable {
    let ScheduleResource : ScheduleResource
    
    struct ScheduleResource : Codable {
        let Schedule : [Schedule]
        let Meta : Meta
    }
}

struct Schedule : Codable {
    let TotalJourney : TotalJourney
    let Flight : Flight
}

struct TotalJourney: Codable {
    let Duration : String
}


enum Flight: Codable {
    case array([FlightObj])
    case object(FlightObj)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .array(container.decode(Array.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .object(container.decode(FlightObj.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(Flight.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
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

struct FlightObj : Codable{
    let Departure : FlightData
    let Arrival : FlightData
    let MarketingCarrier : MarketingCarrier
}

struct FlightData : Codable {
    let AirportCode : String
    let ScheduledTimeLocal : ScheduledTimeLocal
    let Terminal : Terminal?
}


struct ScheduledTimeLocal : Codable {
    let DateTime : String
}

struct Terminal : Codable {
    let Name : Int
}

struct MarketingCarrier : Codable {
    let AirlineID : String    
}
struct Meta : Codable {
    
}
