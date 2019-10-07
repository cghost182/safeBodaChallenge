//
//  AirportResponseMock.swift
//  safeBodaChallengeTests
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
@testable import safeBodaChallenge

let airportCoordinateMock = AirportCoordinate(Latitude: 123, Longitude: 321)
let airportPositionMock = AirportPosition(Coordinate: airportCoordinateMock)
let airportObjMock = AirportObj(AirportCode: "TXL", Position: airportPositionMock, CityCode: "BER", CountryCode: "DE")
let airportMock = Airport.object(airportObjMock)
let airportsMock = Airports(Airport: airportMock)
let airportResourceMock = AirportResource(Airports: airportsMock)
let airportResponseMock = AirportResponse(AirportResource: airportResourceMock)
