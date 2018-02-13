//
//  ViewController.swift
//  TravelHelp
//
//  Created by air on 18.12.2017.
//  Copyright © 2017 dogDeveloper. All rights reserved.
//

import UIKit
import AccountKit
import Firebase
import FacebookCore
import FacebookLogin
import JTMaterialTransition
import TKSubmitTransition
import UIView_Shake
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet private weak var loginFBButton: UIStackView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet private weak var logInEmail: AnimationButton!
    @IBOutlet private weak var logInPhone: AnimationButton!
    @IBOutlet private weak var RegistrationButton: UIButton!
    @IBOutlet private weak var loginButton: TKTransitionSubmitButton!
    
    var accoutnKit: AKFAccountKit!
    //MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupNotification()
        setupInterface()
        authenticateUser()
        checkAccountKit()
    }
    
    func checkAccountKit() {
        if accoutnKit == nil {
            self.accoutnKit = AKFAccountKit(responseType: .accessToken)
        }
    }

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func didStartYourLoading() {
        loginButton.startLoadingAnimation()
    }
    
    func didFinishYourLoading() {
        loginButton.startFinishAnimation(1) {
            let secondVC = MenuViewController()
            secondVC.transitioningDelegate = self
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    guard
                        let email = user?.email,
                        let uid = user?.uid,
                        let name = user?.displayName,
                        let phoneNumber = user?.phoneNumber
                    else {
                        return
                    }
                    DatabaseService.shared.saveUser(uid: uid, email: email, name: name, phoneNumber: phoneNumber)
                    self.performSegue(withIdentifier: "ShowMenu", sender: nil)
                }
            }
        }
    }

    func setupInterface() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        logInEmail.layer.cornerRadius = logInEmail.frame.height / 2
        logInPhone.layer.cornerRadius = logInPhone.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil{
                self?.performSegue(withIdentifier: "ShowMenu", sender: nil)
            }
        }
            if accoutnKit.currentAccessToken != nil {
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "ShowMenu", sender: self)
                        })
            self.performSegue(withIdentifier: "ShowMenu", sender: self)
        }
        if AccessToken.current != nil {
            performSegue(withIdentifier: "ShowMenu", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        print("Succes touch id")
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)
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
    
    // MARK: - Action
    
    @IBAction func loginButton(_ sender: TKTransitionSubmitButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",password != "" else {
            self.view.shake()
            return
        }
        didStartYourLoading()
        AutorizationService.shared.loginUser(email: email, password: password){  [weak self] in
            self?.didFinishYourLoading()
        }
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
       performSegue(withIdentifier: "RegNewPerson", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMwnu"{
            let dvc = segue.destination as! RegistrationNewPersonViewController
            dvc.emailTextField.text = emailTextField.text
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText(){
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
}

extension LoginViewController: AKFViewControllerDelegate {
    @IBAction func logInEmail(_ sender: AnimationButton) { // Login with email
        
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func logInPhone(_ sender: AnimationButton) {  // Login  with phone number
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

