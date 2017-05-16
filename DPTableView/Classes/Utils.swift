//
// Created by Danil Pestov on 20.03.17.
// Copyright (c) 2016 HOKMT. All rights reserved.
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
