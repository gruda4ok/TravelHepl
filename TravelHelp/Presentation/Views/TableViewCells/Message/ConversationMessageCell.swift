//
//  ConversationMessageCell.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 12.02.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class ConversationMessageCell: UICollectionViewCell {
    
    var conversationController: ConversationController?
    var message: Message?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.stopAnimating()
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.textColor = .white
        return textView
    }()
    
    static let blueColor = UIColor(red: 0, green: 137, blue: 249, alpha: 1)
    static let greyColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    
    let bubbleMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    var bubbleMessageWidthAnchor: NSLayoutConstraint?
    var bubbleMessageRightAnchor: NSLayoutConstraint?
    var bubbleMessageLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleMessageView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        bubbleMessageView.addSubview(messageImageView)
        bubbleMessageView.addSubview(activityIndicatorView)
        
        setupBubbleMessageView()
        setupActivityIndicatorView()
        setupMessageTextView()
        setupMessageImageView()
        setupProfileImageView()
    }
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            print(imageView.constraints)
            self.conversationController?.performZooming(startsImageView: imageView)
        }
    }
    
    func setupActivityIndicatorView() {
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleMessageView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleMessageView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func setupMessageImageView() {
        messageImageView.leftAnchor.constraint(equalTo: bubbleMessageView.leftAnchor).isActive = true
        messageImageView.rightAnchor.constraint(equalTo: bubbleMessageView.rightAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleMessageView.topAnchor).isActive = true
        messageImageView.bottomAnchor.constraint(equalTo: bubbleMessageView.bottomAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func setupBubbleMessageView() {
        bubbleMessageRightAnchor = bubbleMessageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleMessageRightAnchor?.isActive = true
        bubbleMessageLeftAnchor = bubbleMessageView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleMessageLeftAnchor?.isActive = false
        bubbleMessageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleMessageWidthAnchor = bubbleMessageView.widthAnchor.constraint(equalToConstant: 200)
        bubbleMessageWidthAnchor?.isActive = true
        bubbleMessageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupMessageTextView() {
        messageTextView.leftAnchor.constraint(equalTo: bubbleMessageView.leftAnchor, constant: 8).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: bubbleMessageView.rightAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
