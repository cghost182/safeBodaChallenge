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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedulesTableView.delegate = self
        schedulesTableView.dataSource = self
        schedulesTableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "scheduleTableCell")
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
        let cell = tableView.cellForRow(at: indexPath) as! SchedulesTableViewCell
        cell.selectCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SchedulesTableViewCell
        cell.deSelectCell()
    }
    
    
}
