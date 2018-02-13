//
//  DatabaseService.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias TravelsSnapshotClosureType = (_ travels: Array<TravelBase>) -> Void
typealias RoutesSnapshotClosureType = (_ routes: Array<RouteBase>) -> Void
typealias UsersSnapshotClosureType  = (_ users: Array<UserModel>) -> Void

class DatabaseService {
    
    static let shared = DatabaseService()
   
    func saveUser(uid:String, email: String, name: String, phoneNumber: String){
        let ref = Database.database().reference(withPath: "users")
        let userRef = ref.child(uid)
        userRef.setValue(["email": email])
        let nameRef = ref.child(uid).child("Name")
        nameRef.setValue(name)
        let phoneRef = ref.child(uid).child("PhoneNumber")
        phoneRef.setValue(phoneNumber)
        let uidRef = ref.child(uid).child("uid")
        uidRef.setValue(uid)
    }
    
    //MARK: - Snapshot
    
    func snapshotTravel(user: UserModel?, complition: @escaping TravelsSnapshotClosureType){
        guard let user = user else {return}
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        ref.observe(.value) {(snapshot) in
            let travels = snapshot.children.flatMap{
                return TravelBase(snapshot: $0 as! DataSnapshot)
            }
            complition(travels)
        }
    }
    
    func snapshotUser( complition: @escaping UsersSnapshotClosureType) {
        let ref = Database.database().reference(withPath: "users")
        ref.observe(.value){ snapshot in
            let users = snapshot.children.flatMap{
                return UserModel(dictionary: $0 as! [String : AnyObject])
            }
            complition(users)
        }
    }
    
    func snapshotRoutes(complition: @escaping RoutesSnapshotClosureType) {
        let ref = Database.database().reference(withPath: "route")
        ref.observe(.value) {(snapshot) in
            let routes = snapshot.children.flatMap{
                return RouteBase(snapshot: $0 as! DataSnapshot)
            }
            complition(routes)
        }
    }
    
    //MARK: - Add
    
    func addTravel(name: String?, user: UserModel?, dateStart: String?, endDate: String?, discription: String?, route: Array<String>?) -> TravelBase? {
        guard
            let user = user,
            let name = name,
            let dateStart = dateStart,
            let endDate = endDate,
            let discription = discription,
            let route = route
        else {
            return nil
        }
        let ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("travel")
        let travel = TravelBase(travelId: name,
                              userId: user.uid,
                              dateStart: dateStart,
                              endDate: endDate,
                              discription: discription,
                              route: route)
        let travelRef = ref.child(travel.travelId.lowercased())
        travelRef.setValue(travel.convertToDictionary())
        
        return travel
    }
    
    func addRoute(name: String?, user: UserModel?, city: String?, countri: String?, timeRoute: String?) -> RouteBase? {
        guard
            let user = user,
            let name = name,
            let city = city,
            let countri = countri,
            let timeRoute = timeRoute
        else{
            return nil
        }
        let ref = Database.database().reference(withPath: "route")
        let route = RouteBase(routeID: name, userID: user.uid, city: city, countri: countri, timeRoute: timeRoute)
        let routeRef = ref.child(route.routeID.lowercased())
        routeRef.setValue(route.convertToDictionary())
        
        return route
    }
}
