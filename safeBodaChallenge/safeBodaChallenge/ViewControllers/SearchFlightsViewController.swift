//
//  SearchFlightsViewController.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 9/28/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import UIKit

class SearchFlightsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var originButton: CornerRadiusButton!
    @IBOutlet weak var destinationButton: CornerRadiusButton!
    @IBOutlet weak var airportsPicker: UIPickerView!
    @IBOutlet weak var airportsPickerContainer: UIView!
    @IBOutlet weak var searchBoxContainer: CornerRadiusView!
    @IBOutlet weak var searchButton: CornerRadiusButton!
    
    //MARK: - Constraints
    
    @IBOutlet weak var airportsPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var searchFlightsViewModel : SearchFlightsViewModel!
    var schedulesViewController : SchedulesViewController!
    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private var airports:[AirportObj] = []
    private var airportsArray : [String] = []
    private var originAirportsArray : [String] = ["TXL","BOG","FRA"]
    private var destinationAirportsArray : [String] = ["JFK","ZRH","AUS"]
    private var originAirportsNamesArray : [String] = ["Berlin","Bogota","Frankfurt"]
    private var destinationAirportsNamesArray : [String] = ["New York","Zurich","Austin"]
    private var optionSelected : AirportType = .origin
    private var airportPickerVisible = false
    private var originAirportSelectedCode = ""
    private var destinationAirportSelectedCode = ""
    private var originAirportSelected : AirportObj?
    private var destinationAirportSelected : AirportObj?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlightsViewModel = SearchFlightsViewModel(delegate: self)
        searchFlightsViewModel.requestAccessToken()
        
        schedulesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulesView") as? SchedulesViewController
        airportsPicker.delegate = self
        airportsPicker.dataSource = self
        
        setDefaultConfiguration()
        appendActivityIndicator()
        showActivityIndicator()
    }
    

    //MARK: - Private methods
    
    private func setDefaultConfiguration(){
        searchBoxContainer.isHidden = true
        searchButton.isHidden = true
        
        airportsPickerBottomConstraint.constant = airportsPickerContainer.frame.height
        searchBoxTopConstraint.constant = -searchBoxContainer.frame.height
        searchButtonBottomConstraint.constant = 50
        
    }
    
    private func showAirportPicker( type : AirportType ){
        optionSelected = type
        airportsPickerContainer.isHidden = false
        airportsPicker.reloadAllComponents()
        toggleDataPicker()
    }
    
    private func setAirportSelection(airportSelectedIndex : Int){
        showActivityIndicator()
        
        var airportCode = ""
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
        }
        
        if optionSelected == .origin {
            airportCode = originAirportsArray[airportSelectedIndex]
            originAirportSelectedCode = airportCode
            originButton.setTitle(originAirportsNamesArray[airportSelectedIndex], for: .normal)
        }else{
            airportCode = destinationAirportsArray[airportSelectedIndex]
            destinationAirportSelectedCode = airportCode
            destinationButton.setTitle(destinationAirportsNamesArray[airportSelectedIndex], for: .normal)
        }
        
        searchFlightsViewModel.requestAirport(airportCode: airportCode)
        toggleDataPicker()
    }
    
    private func toggleDataPicker(){
        
        UIView.animate(withDuration: 0.4, animations: {
            self.airportsPickerBottomConstraint.constant = self.airportPickerVisible ? self.airportsPickerContainer.frame.height : 0
            self.airportPickerVisible = !self.airportPickerVisible
            self.view.layoutIfNeeded()
        }) { (finished: Bool) in
            self.airportsPickerContainer.isHidden = !self.airportPickerVisible
        }
    }
    
    private func showElements(){
        
        DispatchQueue.main.async {
            self.searchBoxContainer.isHidden = false
            self.searchButton.isHidden = false
            
            UIView.animate(withDuration: 0.4, animations: {
                self.searchBoxTopConstraint.constant =  20
                self.searchButtonBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    private func hideElements(){
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.searchBoxTopConstraint.constant = -self.searchBoxContainer.frame.height
                self.searchButtonBottomConstraint.constant = 50
                self.view.layoutIfNeeded()
            }) { (finished : Bool) in
                self.searchBoxContainer.isHidden = true
                self.searchButton.isHidden = true
            }
        }
    }
    
    private func presentSchedulesView(schedules : [Schedule]){

        schedulesViewController.schedulesArray = schedules
        schedulesViewController.originAirportCoordinates = (Latitude : originAirportSelected?.Position.Coordinate.Latitude, Longitude : originAirportSelected?.Position.Coordinate.Longitude) as? FlightCoordinate
        schedulesViewController.destinationAirportCoordinates = (Latitude : destinationAirportSelected?.Position.Coordinate.Latitude, Longitude : destinationAirportSelected?.Position.Coordinate.Longitude) as? FlightCoordinate
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(self.schedulesViewController, animated: true)
            self.showElements()
            self.hideActivityIndicator()
        }
        
    }
    
    private func appendActivityIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.color = #colorLiteral(red: 0.9308201075, green: 0.5834892392, blue: 0.336384505, alpha: 1)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    

    //MARK: - Actions
    
    @IBAction func airportOptionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            airportsArray = originAirportsNamesArray
            showAirportPicker(type: .origin)
        case 1:
            airportsArray = destinationAirportsNamesArray
            showAirportPicker(type: .destination)
        default:
            break
        }
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        if ( originAirportSelectedCode == "" || destinationAirportSelectedCode == "" ){
            presentAlertMessage(message: "Please select origin and destination",navigationController: navigationController!)
            return
        }
        
        self.hideElements()
        self.showActivityIndicator()
        
        searchFlightsViewModel.requestSchedules(originAirport: originAirportSelectedCode, destinationAirport: destinationAirportSelectedCode, flightDate: "2019-11-24")
    }
    
    @IBAction func closePicker(_ sender: Any) {
        let rowSelected = airportsPicker.selectedRow(inComponent: 0)
        setAirportSelection(airportSelectedIndex: rowSelected)
    }
    
}

extension SearchFlightsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return airportsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return airportsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
}


extension SearchFlightsViewController : SearchFlightsViewModelDelegate {
    func didSetAccessToken(){
        self.showElements()
        self.hideActivityIndicator()
    }
    
    func setAirports(airports:[AirportObj]) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
        }
        
        if optionSelected == .origin {
            originAirportSelected = airports.first
        }else{
            destinationAirportSelected = airports.first
        }
        
        hideActivityIndicator()
        
    }
    
    func setSchedules(schedules : [Schedule]) {
        presentSchedulesView(schedules : schedules)
    }
    
    func presentErrorMessage(error :Error){
        presentAlertMessage(message: error.localizedDescription, navigationController: navigationController!)
        DispatchQueue.main.async {
            self.showElements()
            self.hideActivityIndicator()
        }

    }
    
}
