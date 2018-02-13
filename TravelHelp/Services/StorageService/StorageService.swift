//
//  StoregService.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 16.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias DownloadImageURLClosure = (_ url: URL?) -> Void

class StorageService {
    static let shared = StorageService()
    var user: UserModel? = AutorizationService.shared.localUser

    private init() {}
    
    //MARK: - AvatarImage
    
    func saveAvatarImage(image: Image, user: UserModel?) {
        guard let user = user else { return }
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("Avatar").child(user.uid)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            }
            uploadTask.resume()
        }
    }
    
    func avatarImage(user: UserModel?, completion: @escaping DownloadImageURLClosure){
        guard let user = user else { return }
        let storageRef = Storage.storage().reference().child("Avatar").child(user.uid)
        storageRef.downloadURL(completion: { (url, error) in
            completion(url)
        })
    }
    
    //MARK: - RoutesImage
    
    func saveRouteImage(image: Image, route: RouteBase?) {
        guard
            let route = route
        else {
            return
        }
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("Routes").child(route.routeID)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            }
            uploadTask.resume()
        }
    }
    
    func routeImage(route: RouteBase?, completion: @escaping DownloadImageURLClosure){
        guard let route = route else {return}
        let storageRef = Storage.storage().reference().child("Routes").child(route.routeID)
        storageRef.downloadURL(completion: { (url, error) in
            completion(url)
        })
    }

    //MARK: - TravelImage
    
    func saveImageTravel(image: Image, user: UserModel?, travel: TravelBase?, complition: @escaping EmptyClosureType) {
        guard
            let user = user,
            let travel = travel
        else {
            return
        }
        if let data = image.data{
            let storageRef = Storage.storage().reference().child("ImageTravel").child(user.uid).child(travel.travelId)
            let metadata = StorageMetadata()
            metadata.contentType = image.contentType
            let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
                complition()
            }
            uploadTask.resume()
        }
    }
    
    func travelImage(user: UserModel?, travel: TravelBase?, completion: @escaping DownloadImageURLClosure){
        guard
            let user = user,
            let travel = travel
        else {
            return
        }
        let storageRef = Storage.storage().reference().child("ImageTravel").child(user.uid).child(travel.travelId)
        storageRef.downloadURL(completion: { (url, error) in
            completion(url)
        })
    }
}
