//
//  MenuViewController.swift
//  TravelHelp
//
//  Created by air on 18.12.2017.
//  Copyright © 2017 dogDeveloper. All rights reserved.
//

import UIKit
import AccountKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class MenuViewController: UIViewController  {
    
    @IBOutlet private weak var logOut: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    private var accoutnKit: AKFAccountKit!
    private let menuArray: Array<String> = ["Travel", "routes", "Message"]
    
    //MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupAccoutKit()
    }
    
    func setupInterface() {
        //tableView.tableFooterView = UIView()
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor.clear
    }
    
    func setupAccoutKit() {
        if accoutnKit == nil{
            self.accoutnKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    
    //MARK: - Action
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        accoutnKit.logOut()
        try? Auth.auth().signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        dismiss(animated: true, completion: nil)
        
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "ShowTravelTable", sender: nil)
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "ShowRoutes", sender: nil)
        }
        if indexPath.row == 2 {
            performSegue(withIdentifier: "ShowMessage", sender: nil)
        }
    }
}
