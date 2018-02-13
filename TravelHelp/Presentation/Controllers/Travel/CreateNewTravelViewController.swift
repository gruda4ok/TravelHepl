//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import PKHUD

class CreateNewTravelViewController: UIViewController {
   
    @IBOutlet private weak var showQRCodeButton: UIButton!
    @IBOutlet private weak var qrCodeImage: UIImageView!
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var travelPhotoImage: UIImageView!
    @IBOutlet private weak var addPhoto: UIButton!
    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var nameTravelTextField: UITextField!
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    @IBOutlet private weak var routeTableView: UITableView!
    @IBOutlet private weak var placeStayTableView: UITableView!
    @IBOutlet private weak var pricesTableView: UITableView!
    @IBOutlet private weak var requirementTableView: UITableView!
    @IBOutlet private weak var discriptionTextField: UITextField!
    
    private var map: GMSMapView!
    private var marker: GMSMarker!
    private var places: Array<GMSPlace> = []
    private var placesName: Array<String> = []
    private var user: UserModel? = AutorizationService.shared.localUser
    private var placesClient: GMSPlacesClient!
    private var imageModel: Image?
    private var travel: TravelBase?
    private var placeStayArray: Array<String> = []
    private var priceArray: Array<String> = []
    private var requirementArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupInterface()
        setupNotification()
        setupMap()
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupInterface() {
        addPhoto.layer.cornerRadius = addPhoto.frame.height / 6
        createButton.layer.cornerRadius = createButton.frame.height / 2
        nameTravelTextField.delegate = self
        discriptionTextField.delegate = self
        nameTravelTextField.keyboardAppearance = .dark
        discriptionTextField.keyboardAppearance = .dark
        qrCodeImage.isHidden = true
        
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func setupQRCode() {
        if nameTravelTextField.text != "",
            startDatePicker.date.description != "",
            endDatePicker.date.description != "",
            discriptionTextField.text != ""{
            let qrCodeString = "Name = \(String(describing: nameTravelTextField.text)),date start = \(startDatePicker.date.description)), end date = \(endDatePicker.date.description)), discription = \(String(describing: discriptionTextField.text))"
            qrCodeImage.image = qrCodeString.qrcodeImage
        }
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
    
    @IBAction func create(_ sender: UIButton) {
        guard
            let name = nameTravelTextField.text,
            let dateStart = startDatePicker?.date.description,
            let endDate = endDatePicker?.date.description,
            let discription = discriptionTextField.text,
            name != "",
            dateStart != "",
            endDate != "",
            discription != ""
        else{
            return
        }
        HUD.show(.progress)
        self.travel = DatabaseService.shared.addTravel(name: name,
                                                 user: user,
                                                 dateStart: dateStart,
                                                 endDate: endDate,
                                                 discription: discription,
                                                 route: placesName)
        if let image = self.imageModel,
            let user = AutorizationService.shared.localUser,
            let travel = self.travel {
            StorageService.shared.saveImageTravel(image: image, user: user, travel: travel){
                HUD.hide()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.settings.myLocationButton = true
        map.settings.compassButton = true
        map.isMyLocationEnabled = true
        map.frame = mapView.bounds
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(map)
        
        if let myLocation = map?.myLocation {
            print("User location\(myLocation)")
        }else{
            print("Not found user location")
        }
    }
    
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
    @IBAction func addPlace(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func addPlaceStayButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add place stay", message: "Add place of residence to travel", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name place"
        }
    
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (alert) -> Void in
            let namePlace = alertController.textFields!.first
            self.placeStayArray.append((namePlace?.text)!)
            self.placeStayTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor.black
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addPriceButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add price", message: "Add the expenses associated with the trip", preferredStyle: .alert)
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = sender
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Price"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Price for"
            textField.keyboardType = .default
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (alert) -> Void in
            let price = alertController.textFields?.first
            self.priceArray.append((price?.text)!)
            self.pricesTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.view.tintColor = UIColor.black
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addRequirementButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add price", message: "Add the expenses associated with the trip", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Requirement"
            textField.keyboardType = .default
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (alert) -> Void in
            let requirement = alertController.textFields?.first
            self.requirementArray.append((requirement?.text!)!)
            self.requirementTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor.black
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func showQRcodeButton(_ sender: UIButton) {
        var qrCodeString = ""
        qrCodeImage.isHidden = false
        showQRCodeButton.isHidden = true
        if nameTravelTextField.text != "",
            startDatePicker.date.description != "",
            endDatePicker.date.description != "",
            discriptionTextField.text != ""{
             qrCodeString = "Name = \(String(describing: nameTravelTextField.text)),date start = \(startDatePicker.date.description)), end date = \(endDatePicker.date.description)), discription = \(String(describing: discriptionTextField.text))"
        }
        qrCodeImage.image = qrCodeString.qrcodeImage
    }
}

extension CreateNewTravelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func addPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerImageURL] as? NSURL,
            let pathExtension = url.pathExtension {
            travelPhotoImage.image = image
            addPhoto.isHidden = true
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

extension  CreateNewTravelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTravelTextField.endEditing(true)
        discriptionTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText(){
        nameTravelTextField.endEditing(true)
        discriptionTextField.endEditing(true)
    }
}

extension CreateNewTravelViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        places.append(place)
        placesName.append(place.name)
        routeTableView.reloadData()
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.map = map
        if  let lastPlace = places.last,
            let preLastPlace = places.dropLast().last{
            DirectionService.shared.getDirection(firstPlace: lastPlace, secondPlace: preLastPlace, completion: { (direction) in
                let routes = direction?.routes
                DispatchQueue.main.async {
                    for route in routes!{
                        let routeOverviewPolyline = route.overview_polyline
                        let points = routeOverviewPolyline.points
                        let path = GMSPath(fromEncodedPath: points)
                        let polyline = GMSPolyline(path: path)
                        polyline.strokeWidth = 4
                        polyline.strokeColor = .red
                        polyline.map = self.map
                    }
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func placeAutocomplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery("Sydney Oper", bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID))")
                }
            }
        })
    }
}

extension CreateNewTravelViewController: UITableViewDelegate {
    
}

extension CreateNewTravelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == routeTableView{
            return placesName.count
        }else if tableView == placeStayTableView{
            return placeStayArray.count
        }else if tableView == pricesTableView{
            return priceArray.count
        }else{
            return requirementArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == routeTableView{
            let cell = routeTableView.dequeueReusableCell(withIdentifier: "CellMap", for: indexPath)
            cell.textLabel?.text = placesName[indexPath.row]
            return cell
        }else if tableView == placeStayTableView{
            let cell = placeStayTableView.dequeueReusableCell(withIdentifier: "CellStayPlace", for: indexPath)
            cell.textLabel?.text = placeStayArray[indexPath.row]
            return cell
        }else if tableView == pricesTableView{
            let cell = pricesTableView.dequeueReusableCell(withIdentifier: "CellPrices", for: indexPath)
            cell.textLabel?.text = priceArray[indexPath.row]
            return cell
        }else{
            let cell = requirementTableView.dequeueReusableCell(withIdentifier: "CellRequirement", for: indexPath)
            cell.textLabel?.text = requirementArray[indexPath.row]
            return cell
        }
    }
}

extension CreateNewTravelViewController: GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
