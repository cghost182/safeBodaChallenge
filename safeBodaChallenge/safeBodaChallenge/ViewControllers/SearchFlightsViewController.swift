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
    @IBOutlet weak var airportsPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var airportsPickerContainer: UIView!
    
    
    //MARK: - Variables
    var searchFlightsViewModel : SearchFlightsViewModel!
    private var airportsArray : [String] = ["TXL","BOG","AUS"]
    private var optionSelected : AirportType = .origin
    private var airportPickerVisible = false
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlightsViewModel = SearchFlightsViewModel(delegate: self)
        searchFlightsViewModel.requestAirports()
        airportsPicker.delegate = self
        airportsPicker.dataSource = self
        airportsPickerBottomConstraint.constant = airportsPickerContainer.frame.height
    }
    
    
    //MARK: - Private methods
    
    private func showAirportPicker( type : AirportType ){
        optionSelected = type
        airportsPickerContainer.isHidden = false
        toggleDataPicker()
    }
    
    private func setAirportSelection(airportCode : String){
        if optionSelected == .origin {
            originButton.setTitle(airportCode, for: .normal)
        }else{
            destinationButton.setTitle(airportCode, for: .normal)
        }
        
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

    //MARK: - Actions
    
    @IBAction func airportOptionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showAirportPicker(type: .origin)
        case 1:
            showAirportPicker(type: .destination)
        default:
            break
        }
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
    }
    
    @IBAction func closePicker(_ sender: Any) {
        let rowSelected = airportsPicker.selectedRow(inComponent: 0)
        setAirportSelection(airportCode: airportsArray[rowSelected])
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
    func setAirports(airports:[AirportObj]) {
        airportsArray = airports.map({ $0.AirportCode })
        DispatchQueue.main.async {
            self.airportsPicker.reloadAllComponents()
        }
        
    }
    
    func setSchedules() {
        //do something
    }
    
    func presentErrorMessage(error :Error){
        let errorAlert = UIAlertController(title: "Opps!", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
    
}
