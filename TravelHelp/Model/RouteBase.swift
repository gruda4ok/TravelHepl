//
//  RouteBase.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

struct RouteBase {
    let routeID: String
    let userID: String
    let city: String
    let countri: String
    let timeRoute: String
    
    init(routeID: String, userID: String, city: String, countri: String, timeRoute: String) {
        self.routeID = routeID
        self.userID = userID
        self.city = city
        self.countri = countri
        self.timeRoute = timeRoute
    }
    init?(snapshot: DataSnapshot) {
        guard
            let snapshotValue = snapshot.value as? [String: String],
            let routeID = snapshotValue["routeID"]
        else{
            return nil
        }
        self.routeID = routeID
        userID = snapshotValue["userID"] ?? ""
        city = snapshotValue["city"] ?? ""
        countri = snapshotValue["countri"] ?? ""
        timeRoute = snapshotValue["timeRoute"] ?? ""
    }
    
    func convertToDictionary() -> Any {
        return ["routeID":routeID,
               "userID": userID,
               "city": city,
               "countri": countri,
               "timeRoute": timeRoute]
    }
}
