//
//  TravelTableViewCell.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Kingfisher

class TravelTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var travelImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var discriptionLabel: UILabel!
    @IBOutlet private weak var dateStartLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    
    func configurate(travel: TravelBase){
        titleLabel.text = travel.travelId
        discriptionLabel.text = travel.discription
        dateStartLabel.text = travel.dateStart
        endDateLabel.text = travel.endDate
        StorageService.shared.travelImage(user: AutorizationService.shared.localUser, travel: travel) { [weak self] url in
            self?.travelImageView.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        discriptionLabel.text = nil
        dateStartLabel.text = nil
        endDateLabel.text = nil
        travelImageView.image = nil
    }
}
