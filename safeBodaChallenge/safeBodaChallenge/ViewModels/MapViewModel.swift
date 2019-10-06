//
//  MapViewModel.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/6/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewModelDelegate : class {
    func addPolyline ( polyLine : MKPolyline)
    func setCenter( center : CLLocationCoordinate2D)
    func addAnnotation(annotation : MKPointAnnotation)
}

class MapViewMdel : NSObject {
    
    private weak var delegate : MapViewModelDelegate?
    
    init(delegate : MapViewModelDelegate){
        self.delegate = delegate
    }
    
    func configureAnnotations(originAirportCoordinates: ( Latitude : Double, Longitude :  Double ), destinationAirportCoordinates: ( Latitude : Double, Longitude :  Double )){
        let originAirportAnnotation = MKPointAnnotation()
        let destinationAirportAnnotation = MKPointAnnotation()
        
        originAirportAnnotation.coordinate = CLLocationCoordinate2D(latitude: originAirportCoordinates.Latitude , longitude: originAirportCoordinates.Longitude )
        destinationAirportAnnotation.coordinate = CLLocationCoordinate2D(latitude: destinationAirportCoordinates.Latitude , longitude: destinationAirportCoordinates.Longitude )
        let airportsCoordinates = [originAirportAnnotation.coordinate, destinationAirportAnnotation.coordinate ]
        let flightPolyline = MKPolyline(coordinates: airportsCoordinates, count: airportsCoordinates.count)
        
        delegate?.setCenter(center: originAirportAnnotation.coordinate)
        delegate?.addAnnotation(annotation: originAirportAnnotation)
        delegate?.addAnnotation(annotation: destinationAirportAnnotation)
        delegate?.addPolyline(polyLine: flightPolyline)
    }
    
}
