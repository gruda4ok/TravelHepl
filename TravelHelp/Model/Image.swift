//
//  Image.swift
//  TravelHelp
//
//  Created by Nikita  Kuratnik on 16.01.18.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class Image {
    
    enum ImageType: String {
        case png = "png"
        case jpeg = "jpeg"
    }
    
    private let type: ImageType?
    private let image: UIImage
    
    init(image: UIImage, extention: String) {
        self.image = image
        self.type = ImageType(rawValue: extention.lowercased())
    }
    
    var data: Data?{
        if type == .png{
            return UIImagePNGRepresentation(image)
        }else if type == .jpeg{
            return UIImageJPEGRepresentation(image, 1.0)
        }else{
            return nil
        }
    }
    
    var contentType: String{
        return "image/\(type?.rawValue ?? "")"
    }
}
