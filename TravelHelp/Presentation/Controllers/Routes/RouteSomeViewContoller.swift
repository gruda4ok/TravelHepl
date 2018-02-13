//
//  RouteComeViewContoller.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 29.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class RouteSomeViewContoller: UIViewController {

    @IBOutlet private weak var routeImage: UIImageView!
    @IBOutlet private weak var roouteNameLabel: UILabel!
    @IBOutlet private weak var routeTimeLabel: UILabel!
    @IBOutlet private weak var routeCountryLabel: UILabel!
    @IBOutlet private weak var routeCityLabel: UILabel!
    
    var route: RouteBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    func setupInterface() {
        guard let route = route else { return }
        roouteNameLabel.text = route.routeID
        routeTimeLabel.text = route.timeRoute
        routeCityLabel.text = route.city
        routeCountryLabel.text = route.countri
        
        StorageService.shared.routeImage(route: route) { [weak self] url in
            self?.routeImage.kf.setImage(with: url)
        }
    }
}
