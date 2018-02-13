//
//  ProfileViewController.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 16.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
   
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var user: UserModel? = AutorizationService.shared.localUser
    var travel: TravelBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil{
            guard let user = user else { return }
            let nameRef = Database.database().reference().child(user.uid).child("Name")
            print(nameRef)
            nameLabel.text = user.email
        }
        StorageService.shared.avatarImage(user: AutorizationService.shared.localUser) { [weak self] url  in
            self?.avatarImage.kf.setImage(with: url)
        }
        avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    }
}
