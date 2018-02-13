//
//  Users.swift
//  TravelHelp
//
//  Created by air on 05.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

class UserModel {
    
    let uid: String
    let email: String
   
    init?(user: User?) {
        guard
            let user = user,
            let email = user.email
        else {
            return nil
        }
        self.uid = user.uid
        self.email = email
    }
    init?(dictionary: DataSnapshot) {
        guard let snapshotValue = dictionary.value as? [String: AnyObject] else  {return nil}
        self.uid = snapshotValue["uid"] as? String ?? ""
        self.email = snapshotValue["email"] as? String ?? ""
    }
}
