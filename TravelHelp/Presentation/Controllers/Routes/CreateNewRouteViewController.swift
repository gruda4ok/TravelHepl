//
//  CreateNewRouteViewController.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 22.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import PKHUD

class CreateNewRouteViewController: UIViewController {

    @IBOutlet private weak var timeRouteTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var countriTextField: UITextField!
    @IBOutlet private weak var addPhoto: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var routeImage: UIImageView!
    @IBOutlet private weak var mapView: UIView!
    private var route: RouteBase?
    private var user: UserModel? = AutorizationService.shared.localUser
    private var map: GMSMapView!
    private var marker: GMSMarker!
    private var placesClient: GMSPlacesClient!
    private var places: Array<GMSPlace> = []
    private var imageModel: Image?
    
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
        nameTextField.delegate = self
        cityTextField.delegate = self
        countriTextField.delegate = self
        timeRouteTextField.delegate = self
        nameTextField.keyboardAppearance = .dark
        cityTextField.keyboardAppearance = .dark
        countriTextField.keyboardAppearance = .dark
        timeRouteTextField.keyboardAppearance = .dark
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

    @IBAction func createButton(_ sender: UIButton) {
        guard
            let name = nameTextField.text,
            let city = cityTextField.text,
            let countri = countriTextField.text,
            let timeRoute = timeRouteTextField.text,
            name != "",
            city != "",
            countri != "",
            timeRoute != ""
        else {
            return
        }
        HUD.show(.progress)
        self.route = DatabaseService.shared.addRoute(name: name, user: user, city: city, countri: countri, timeRoute: timeRoute)
        if let imageRoute = self.imageModel {
            StorageService.shared.saveRouteImage(image: imageRoute, route: route)
            HUD.hide()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addPlace(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension  CreateNewRouteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
        countriTextField.endEditing(true)
        cityTextField.endEditing(true)
        timeRouteTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText(){
        nameTextField.endEditing(true)
        countriTextField.endEditing(true)
        cityTextField.endEditing(true)
        timeRouteTextField.endEditing(true)
    }
}

extension CreateNewRouteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
            routeImage.image = image
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

extension CreateNewRouteViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        places.append(place)
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
            dismiss(animated: true, completion: nil)
        }
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

