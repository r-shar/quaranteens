//
//  CustomLabel.swift
//  Quaranteen Project
//
//  Created by Charlize Dang on 2020-06-19.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0{ 
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }
}
