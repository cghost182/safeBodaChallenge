//
//  SchedulesViewController.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/4/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
import UIKit

class SchedulesViewController : UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var schedulesTableView: UITableView!
    
    //MARK: - Variables
    
    var schedulesArray : [Schedule] = []
    var originAirportCoordinates : FlightCoordinate!
    var destinationAirportCoordinates : FlightCoordinate!
    private var mapViewController : MapViewController!
    private var indexScheduleSelected : IndexPath?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Schedules"
        schedulesTableView.delegate = self
        schedulesTableView.dataSource = self
        schedulesTableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "scheduleTableCell")
        mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapView") as? MapViewController
    }
    
    //MARK: - Public methods
    
    public func setDetails(originAirportCoordinates : FlightCoordinate , destinationAirportCoordinates : FlightCoordinate){
        self.originAirportCoordinates = originAirportCoordinates
        self.destinationAirportCoordinates = destinationAirportCoordinates
    }
    
    //MARK: - Actions
    
    @IBAction func selectScheduleAction(_ sender: Any) {
        var flightDetails : [String:String] = [:]
        
        if let indexScheduleSelected = indexScheduleSelected {
            let selectedCell = schedulesTableView.cellForRow(at: indexScheduleSelected) as? SchedulesTableViewCell
           
            flightDetails["originAirport"] = selectedCell?.originAirportLbl.text
            flightDetails["destinationAirport"] = selectedCell?.destinationAirportLbl.text
            flightDetails["departureTime"] = selectedCell?.departureTimeLbl.text
            flightDetails["arrivalTime"] = selectedCell?.arrivalTimeLbl.text
            flightDetails["duration"] = selectedCell?.flightDurationLbl.text
            
            mapViewController.setDetails(originAirportCoordinates: self.originAirportCoordinates, destinationAirportCoordinates: self.destinationAirportCoordinates, flightDetails: flightDetails)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(self.mapViewController, animated: true)
            }
        }else{
            presentAlertMessage(message: "Please select one schedule",navigationController: navigationController!)
        }        
        
    }
    
}

extension SchedulesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = schedulesTableView.dequeueReusableCell(withIdentifier: "scheduleTableCell", for: indexPath) as! SchedulesTableViewCell
        cell.configureCell(schedule: schedulesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexScheduleSelected = indexPath
        let cell = tableView.cellForRow(at: indexPath) as! SchedulesTableViewCell
        cell.selectCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SchedulesTableViewCell
        cell.deSelectCell()
    }
    
    
}
