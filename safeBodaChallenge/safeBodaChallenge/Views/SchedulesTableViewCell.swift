//
//  SchedulesTableViewCell.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/5/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import UIKit

class SchedulesTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var scheduleCell: UIView!
    @IBOutlet weak var radioButtonImg: UIImageView!
    @IBOutlet weak var originAirportLbl: UILabel!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var stopsLbl: UILabel!
    @IBOutlet weak var flightDurationLbl: UILabel!
    @IBOutlet weak var destinationAirportLbl: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    
    //MARK: - Lifecicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupForReuse()
    }

    //MARK: - Public methods
    
    func configureCell(schedule : Schedule ){
    
        switch schedule.Flight {
        case .array(let array):
            configureDepartureFlight(flight: array.first!)
            configureArrivalFlight(flight: array.last!)
            self.stopsLbl.text = "\(array.count) Stops"
        case .object(let object):
            configureDepartureFlight(flight: object)
            configureArrivalFlight(flight: object)
            self.stopsLbl.text = "Direct"
        }
        
        self.flightDurationLbl.text = schedule.TotalJourney.Duration.components(separatedBy: "T")[1]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private methods
    
    private func configureDepartureFlight(flight : FlightObj){
        self.originAirportLbl.text = flight.Departure.AirportCode
        self.departureTimeLbl.text = flight.Departure.ScheduledTimeLocal.DateTime.components(separatedBy: "T")[1]
    }
    
    private func configureArrivalFlight(flight : FlightObj){
        self.destinationAirportLbl.text = flight.Arrival.AirportCode
        self.arrivalTimeLbl.text = flight.Arrival.ScheduledTimeLocal.DateTime.components(separatedBy: "T")[1]
    }
    
    private func setupForReuse(){
        scheduleCell.layer.borderWidth = 0.5
        scheduleCell.layer.borderColor = #colorLiteral(red: 0.9308201075, green: 0.5834892392, blue: 0.336384505, alpha: 1)
        scheduleCell.layer.cornerRadius = 5
        radioButtonImg.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.628130351)
    }
    
}
