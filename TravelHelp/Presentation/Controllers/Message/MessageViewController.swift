//
//  MessageViewController.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 12.02.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    private var timer: Timer?
    private var messages = Array<Message>()
    private var messageDictinory = Dictionary<String,Message>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    @IBAction func addChat(_ sender: UIBarButtonItem) {
        print("Go")
    }
}

extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
}

// MARK: - Messages Action

fileprivate extension MessageViewController {
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let reference = Database.database().reference().child("user-messages").child(uid)
        reference.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            let userId = snapshot.key
            let conversationReference = Database.database().reference().child("user-messages").child(uid).child(userId)
            conversationReference.observe(.childAdded, with: {(snapshot) in
                let messageId = snapshot.key
                strongSelf.fetchMessageAndAttemptReaload(messageId: messageId)
            }, withCancel: nil)
            }, withCancel: nil)
        reference.observe(.childRemoved, with: { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            strongSelf.messageDictinory.removeValue(forKey: snapshot.key)
            }, withCancel: nil)
    }
    
    private func fetchMessageAndAttemptReaload(messageId: String) {
        let messageReference = Database.database().reference().child("messages").child(messageId)
        messageReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartner = message.chatPartnerId() {
                    self?.messageDictinory[chatPartner] = message
                }
                self?.messageTableView.reloadData()
            }
            }, withCancel: nil)
    }
    
    func observeMessages() {
        let reference = Database.database().reference().child("messages")
        reference.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let message = Message(dictionary: dictionary)
                if let receiver = message.receiver {
                    self?.messageDictinory[receiver] = message
                    self?.messages = Array(self!.messageDictinory.values)
                    self?.messages.sort{(message1, message2) -> Bool in
                        return  (message2.timestamp != nil)
                    }
                }
                DispatchQueue.main.async {
                    self?.messageTableView.reloadData()
                }
            }
            }, withCancel: nil)
    }
}

// MARK: - Transitions

extension MessageViewController {
    
    private func showConversationControllerForUser(indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {return}
        let reference = Database.database().reference().child("users").child(chatPartnerId)
        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let dictionarys = snapshot.value as? [String: AnyObject] else {
                return
            }
            let user = UserModel(dictionary: dictionarys )
            self?.showConversationController(forUser: user! )
            }, withCancel: nil)
    }
    
    func showConversationController(forUser user: UserModel?) {
        let conversationController = ConversationController(collectionViewLayout: UICollectionViewFlowLayout())
        conversationController.user = user
        navigationController?.pushViewController(conversationController, animated: true)
    }
}
