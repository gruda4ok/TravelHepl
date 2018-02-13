//
//  File.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

struct TravelBase {
    let travelId: String
    let userId: String
    let dateStart: String
    let endDate: String
    let discription: String
    let route: Array<String>
    
    init( travelId: String, userId: String, dateStart: String, endDate: String, discription: String, route: Array<String>) {
        self.travelId = travelId
        self.userId = userId
        self.dateStart = dateStart
        self.endDate = endDate
        self.discription = discription
        self.route = route
    }

    init?(snapshot: DataSnapshot) {
        guard
            let snapshotValue = snapshot.value as? [String: Any],
            let travelId = snapshotValue["travelId"]
        else{
            return nil
        }
        self.travelId = travelId as! String
        userId = snapshotValue["userId"]  as? String ?? ""
        dateStart = snapshotValue["dateStart"] as? String ?? ""
        endDate = snapshotValue["endDate"] as? String ?? ""
        discription = snapshotValue["discription"] as? String ?? ""
        route = [snapshotValue["route"] as? String ?? ""]
    }
    
    func convertToDictionary() -> Any {
        return ["travelId":travelId,
                "userId": userId,
                "dateStart": dateStart,
                "endDate": endDate,
                "discription": discription,
                "route": route]
    }
}
