//
//  RoutesTableViewCell.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Kingfisher

class RoutesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var routeImage: UIImageView!
    @IBOutlet private weak var routeNameLabel: UILabel!
    
    func configurate(route: RouteBase){
        routeNameLabel.text = route.routeID
        StorageService.shared.routeImage(route: route) { [weak self] url in
            self?.routeImage.kf.setImage(with: url)
        }
    }
    
     override func prepareForReuse() {
        routeNameLabel.text = nil
    }
}
