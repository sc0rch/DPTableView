//
//  Utils.swift
//  Pods
//
//  Created by i20 on 20.03.17.
//
//

import UIKit

extension UIView {
    internal class var describing: String {
        return String(describing: self)
    }
    
    internal class var nib: UINib {
        return UINib(nibName: describing, bundle: nil)
    }
}
