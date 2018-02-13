//
//  NetworkServiceProtocol.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 24.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol{
    func get(path: String, parameters: [String: Any]?, completion: @escaping RequestClosure)
    func post(path: String, parameters: [String: Any]?, completion: @escaping RequestClosure)
}
