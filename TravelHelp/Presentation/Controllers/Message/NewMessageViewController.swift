//
//  NewMessageViewController.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 12.02.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    private var users = Array<UserModel>()
    var messagesController: MessageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        self.configure()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.uid
        cell.detailTextLabel?.text = user.email
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.startConversation(indexPath: indexPath)
    }
}

extension NewMessageViewController {
    func configure() {
        self.fetchUser()
    }
    
    func fetchUser() {
        DatabaseService.shared.snapshotUser { [weak self] users in
            self?.reloadTableView(users: users)
        }
    }
    
    func reloadTableView(users: Array<UserModel>) {
        self.users = users
        tableView.reloadData()
    }
}

extension NewMessageViewController {
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startConversation(indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showConversationController(forUser: user)
        }
    }
}
