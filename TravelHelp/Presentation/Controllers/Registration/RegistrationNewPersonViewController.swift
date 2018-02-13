//
//  RegistrationNewPersonViewController.swift
//  TravelHelp
//
//  Created by air on 06.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase
import UIView_Shake

class RegistrationNewPersonViewController: UIViewController {

    @IBOutlet private weak var addPhotoButton: AnimationButton!
    @IBOutlet private weak var photoPersonImage: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registrationButton: AnimationButton!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    
    var imageModel: Image?
    
    //MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupInterface()
        setupNotification()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    private func setupInterface() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func registrationButton(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let phone = phoneNumberTextField.text,
            email != "",
            password != "",
            name != "",
            phone != ""
        else {
            self.view.shake()
            return
        }
        AutorizationService.shared.registerUser(email: email, password: password, name: name, phoneNumber: phone){ [weak self] in
            if  let user = AutorizationService.shared.localUser,
                let image = self?.imageModel{
               StorageService.shared.saveAvatarImage(image: image, user: user)
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification) {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    @objc func keyBoardDidHide() {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
}

extension RegistrationNewPersonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        nameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        nameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
    }
}

extension RegistrationNewPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBAction func addPhotoButton(_ sender: AnimationButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerImageURL] as? NSURL,
            let pathExtension = url.pathExtension {
            photoPersonImage.image = image
            addPhotoButton.isHidden = true
            imageModel = Image(image: image, extention: pathExtension)
        }else{
            print("Error")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
