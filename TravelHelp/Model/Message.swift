//
//  Message.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 12.02.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Message {
    var sender: String?
    var receiver: String?
    var text: String?
    var timestamp: Int?
    
    init(dictionary: Dictionary<String, Any>) {
        self.sender = dictionary["senderId"] as? String
        self.receiver = dictionary["receiverId"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? Int
    }
    
    func chatPartnerId() -> String? {
        return sender == Auth.auth().currentUser?.uid ? receiver:sender
    }
}
