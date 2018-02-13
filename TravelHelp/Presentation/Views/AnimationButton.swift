//
//  AnimationButton.swift
//  TravelHelp
//
//  Created by air on 20.12.2017.
//  Copyright © 2017 dogDeveloper. All rights reserved.
//

import UIKit

class AnimationButton: UIButton {
    
    func shake1(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: bounds.origin.x - 5, y: bounds.origin.y))
        shakeAnimation.byValue = NSValue(cgPoint: CGPoint(x:  bounds.origin.x  + 5, y: bounds.origin.y))
        shakeAnimation.duration = 0.03
        shakeAnimation.repeatCount = 10
        shakeAnimation.autoreverses = true
        layer.add(shakeAnimation, forKey: "position")
    }
    
    func goLeft(){
        let leftAnimation = CABasicAnimation(keyPath: "position")
        leftAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y))
        leftAnimation.toValue = NSValue(cgPoint: CGPoint(x: frame.size.width + 1000, y: center.y))
        leftAnimation.duration = 1
        layer.add(leftAnimation, forKey: "position")
    }
    
    func goRight(){
        let rightAnimation = CABasicAnimation(keyPath: "position")
        rightAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y))
        rightAnimation.toValue = NSValue(cgPoint: CGPoint(x: center.x - 1000, y: center.y))
        rightAnimation.duration = 1
        layer.add(rightAnimation, forKey: "position")
    }
    
    func puls(){
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0.5
        pulseAnimation.duration = 0.06
        pulseAnimation.repeatCount = 100
        layer.add(pulseAnimation, forKey: "transform.scale.x")
    }
}
