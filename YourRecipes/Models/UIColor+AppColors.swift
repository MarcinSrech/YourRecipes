//
//  UIColor+AppColors.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import UIKit

enum Color: Int {
    case background
    case fontWhite
}

extension UIColor {
    class func getColor(for color: Color, with alpha: CGFloat = 1.0) -> UIColor {
        var returnColor: UIColor?
        
        switch color {
        case .background:
            returnColor = UIColor.init(red: 2.0/255.0, green: 47.0/255.0, blue: 64.0/255.0, alpha: alpha)
        case .fontWhite:
            returnColor = UIColor.white
//        default:
//            returnColor = UIColor.black
        }
        
        return returnColor!
    }
    
}
