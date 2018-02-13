//
//  MessageTableViewCell.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 12.02.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameMessageLabel: UILabel!
    @IBOutlet weak var timeMassageLabel: UILabel!
    @IBOutlet weak var detailMessageLabel: UILabel!
    
    var message: Message!
    
    func configurate(message: Message) {
        setupName(message: message)
        nameMessageLabel.text = message.receiver
        timeMassageLabel.text = String(describing: message.timestamp)
        detailMessageLabel.text = message.text
    }
    
    override func prepareForReuse() {
        userImage.image = nil
        nameMessageLabel.text = nil
        timeMassageLabel.text = nil
        detailMessageLabel.text = nil
    }
    
    private func setupName(message: Message) {
        if let id = message.chatPartnerId() {
            let reference = Database.database().reference().child("users").child(id)
            reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    self?.textLabel?.text = dictionary["name"] as? String
                    }
                }, withCancel: nil)
        }
    }
}
