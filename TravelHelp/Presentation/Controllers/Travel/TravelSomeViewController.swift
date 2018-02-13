//
//  ViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class TravelSomeViewController: UIViewController {
    
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var travel: TravelBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    func setupInterface() {
        guard let travel = travel else {return}
        nameLabel.text = travel.travelId
        dateStartLabel.text = travel.dateStart
        endDateLabel.text = travel.endDate
        discriptionLabel.text = travel.discription
    }
}
