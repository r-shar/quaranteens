//
//  CustomTextField.swift
//  Quaranteen Project
//
//  Created by Can Dang on 2020-05-29.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var inset: CGFloat = 0

       override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.insetBy(dx: inset, dy: inset)
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return textRect(forBounds: bounds)
       }
    
}
