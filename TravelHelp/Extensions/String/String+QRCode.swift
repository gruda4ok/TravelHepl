//
//  String+QRCode.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 25.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var qrcodeImage: UIImage {
        let data = self.data(using: .ascii, allowLossyConversion: true)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let img = UIImage(ciImage: (filter?.outputImage?.transformed(by: transform))!)
    
        return img
    }
}
