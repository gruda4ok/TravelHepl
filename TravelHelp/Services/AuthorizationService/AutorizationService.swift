//
//  AutorizationUser.swift
//  TravelHelp
//
//  Created by air on 11.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias EmptyClosureType = () -> Void

class AutorizationService {
    static let shared = AutorizationService()
    
    var localUser: UserModel?{
        return UserModel(user: Auth.auth().currentUser)
    }
    
    func registerUser(email: String, password: String, name: String, phoneNumber: String, completion: @escaping EmptyClosureType) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil , let user = user else {
                print(error!.localizedDescription )
                return
            }
            DatabaseService.shared.saveUser(uid: user.uid, email: email, name: name, phoneNumber: phoneNumber)
            completion()
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping EmptyClosureType){
        Auth.auth().signIn(withEmail: email, password: password) { ( user, error) in
            if error != nil{
                //self?.displayWarnigLabel(withText: "Error occured")
                return
            }
            if user != nil{
                completion()
            }
        }
    }
}
