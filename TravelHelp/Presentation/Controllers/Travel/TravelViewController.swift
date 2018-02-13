//
//  TravelViewController.swift
//  TravelHelp
//
//  Created by air on 10.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class TravelViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var createNewTravel: AnimationButton!
    
    fileprivate var travels: Array<TravelBase> = []
    private var user: UserModel? = AutorizationService.shared.localUser
    
    //MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    func setupInterface() {
        tableView.tableFooterView = UIView()
        createNewTravel.layer.cornerRadius = createNewTravel.frame.height / 2
        tableView.register(UINib(nibName: String(describing: TravelTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TravelTableViewCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseService.shared.snapshotTravel(user: user){[weak self] travels in
            self?.reloadTableView(travels: travels)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? TravelSomeViewController,
            let travel = sender as? TravelBase{
            dvc.travel = travel
        }
    }
}

extension TravelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}

extension TravelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TravelTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TravelTableViewCell.self), for: indexPath) as! TravelTableViewCell
        cell.configurate(travel: travels[indexPath.row])
        return cell
    }
    
    func reloadTableView(travels: Array<TravelBase>) {
        self.travels = travels
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: String(describing: TravelSomeViewController.self), sender: travels[indexPath.row])
    }
}

