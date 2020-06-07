//
//  BorderImageView.swift
//  Quaranteen Project
//
//  Created by Charlize Dang on 2020-06-06.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BorderImageView: UIImageView {
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
}
