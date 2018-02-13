//
//  DirectionService.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

typealias DirectionClosure = (_ direction: Direction?) -> Void

class DirectionService{
    static let shared = DirectionService()

    func getDirection(firstPlace: GMSPlace, secondPlace: GMSPlace, completion: @escaping DirectionClosure) {
        NetworkServiceWithUrlSession.shared.get(path: "https://maps.googleapis.com/maps/api/directions/json",
                                  parameters: ["origin" :"place_id:\(firstPlace.placeID)",
                                    "destination": "place_id:\(secondPlace.placeID)",
                                    "key": "AIzaSyBLTV2SSUBOdqE64iTztDYVAxlpYyj5rJY"],
                                  completion: { (data, error) in
                                    guard
                                        let data = data,
                                        error == nil
                                    else{
                                        return
                                    }
                                    do{
                                        let direction = try JSONDecoder().decode(Direction.self, from: data)
                                        completion(direction)
                                    }catch let error{
                                       print(error.localizedDescription)
                                    }
        })
    }

}
