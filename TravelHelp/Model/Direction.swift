//
//  JSONDirection.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 19.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation

struct Direction: Decodable {
    let routes: Array<Route>
}

struct Route: Decodable {
    let overview_polyline: Polyline
    let summary: String
}
struct Polyline: Decodable {
    let points: String
}

