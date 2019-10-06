//
//  MapViewController.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/5/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var originAirportLbl: UILabel!
    @IBOutlet weak var destinationAirportLbl: UILabel!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    //MARK: - Variables
    private var originAirportCoordinates : FlightCoordinate!
    private var destinationAirportCoordinates : FlightCoordinate!
    private var flightDetails : [String : String] = [:]
    private var mapViewMdel : MapViewMdel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapViewMdel = MapViewMdel(delegate: self)
        navigationItem.title = "Flight details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAnnotations()
        originAirportLbl.text = flightDetails["originAirport"]
        destinationAirportLbl.text = flightDetails["destinationAirport"]
        departureTimeLbl.text = flightDetails["departureTime"]
        arrivalTimeLbl.text = flightDetails["arrivalTime"]
        durationLbl.text = flightDetails["duration"]
    }
    
    //MARK: - Public methods
    
    public func setDetails(originAirportCoordinates : FlightCoordinate , destinationAirportCoordinates : FlightCoordinate, flightDetails : [String : String]){
        self.originAirportCoordinates = originAirportCoordinates
        self.destinationAirportCoordinates = destinationAirportCoordinates
        self.flightDetails = flightDetails
    }
    
    //MARK: - Private methods
    
    private func configureAnnotations(){
        mapViewMdel.configureAnnotations(originAirportCoordinates: originAirportCoordinates, destinationAirportCoordinates: destinationAirportCoordinates)
    }
    
    //MARK: - Actions
    
    @IBAction func finishAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension MapViewController: MapViewModelDelegate {
    func addPolyline ( polyLine : MKPolyline) {
        mapView.addOverlay(polyLine)
    }
    
    func addAnnotation(annotation : MKPointAnnotation){
        mapView.addAnnotation(annotation)
    }
    
    func setCenter( center : CLLocationCoordinate2D){
        mapView.setCenter(center, animated: true)
    }
}

extension MapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let plRenderer = MKPolylineRenderer(overlay: overlay)
            plRenderer.strokeColor = .red
            plRenderer.lineWidth = 3
            plRenderer.lineDashPhase = 2
            plRenderer.lineDashPattern = [NSNumber(value: 1),NSNumber(value:5)]
            
            return plRenderer
        }
        
        return MKPolylineRenderer()
    }
}
