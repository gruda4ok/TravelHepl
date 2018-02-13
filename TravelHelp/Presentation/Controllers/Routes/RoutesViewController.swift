//
//  RoutesViewController.swift
//  TravelHelp
//
//  Created by air on 10.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class RoutesViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var routesTableView: UITableView!
    fileprivate var routesArray: Array<RouteBase> = []
    private var filterData = [RouteBase]()
    private var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupNotification()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseService.shared.snapshotRoutes { [weak self] routes in
            self?.reloadTableView(routes: routes)
        }
    }
    
    func setupSearchBar(){
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.keyboardAppearance = .dark
        routesTableView.separatorStyle = .none
    }
    
    func setupInterface() {
        routesTableView.tableFooterView = UIView()
        routesTableView.register(UINib(nibName: String(describing: RoutesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RoutesTableViewCell.self))
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        routesTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.routesTableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        routesTableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        routesTableView.dg_setPullToRefreshBackgroundColor(routesTableView.backgroundColor!)
    }
    
    deinit {
        routesTableView.dg_removePullToRefresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? RouteSomeViewContoller,
            let route = sender as? RouteBase{
            dvc.route = route
        }
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    
    
    @objc func keyBoardDidShow(notification: Notification){
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

extension RoutesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            view.endEditing(true)
            routesTableView.reloadData()
        } else {
            isSearchMode = true
            filterData = routesArray.filter({$0.routeID == searchBar.text})
            routesTableView.reloadData()
        }
    }
    @objc func dissmisText() {
        searchBar.endEditing(true)
    }
}

extension RoutesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}

extension RoutesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode{
            return filterData.count
        }
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoutesTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoutesTableViewCell.self), for: indexPath) as! RoutesTableViewCell
        if isSearchMode{
            cell.configurate(route: filterData[indexPath.row])
        }else{
            cell.configurate(route: routesArray[indexPath.row])
        }
        return cell
    }
    
    func reloadTableView(routes: Array<RouteBase>) {
        self.routesArray = routes
        routesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: String(describing: RouteSomeViewContoller.self), sender: routesArray[indexPath.row])
    }
}
