//
//  Colors.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func colorForIndex(_ index: Int) -> UIColor {
        switch index % 6 {
        case 0: return UIColor.rgb(r: 299, g: 77, b: 66)
        case 1: return UIColor.rgb(r: 228, g: 128, b: 48)
        case 2: return UIColor.rgb(r: 240, g: 195, b: 48)
        case 3: return UIColor.rgb(r: 35, g: 159, b: 133)
        case 4: return UIColor.rgb(r: 48, g: 173, b: 99)
        default: return UIColor.rgb(r: 47, g: 129, b: 183)
        }
    }
}
