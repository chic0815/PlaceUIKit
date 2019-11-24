//
//  PlaceUI.swift
//  
//
//  Created by Jaesung on 2019/11/24.
//

import Foundation

import UIKit

enum Color {
    case purple
    case lightPurple
    case whiteSnow
    case pink
    case lightPink
}

class PlaceUI {
    static func color(_ color: Color) -> UIColor {
        switch color {
        case .purple:
            return UIColor.init(red: 109 / 255, green: 118 / 255, blue: 181 / 255, alpha: 1.0)
        case .lightPurple:
            return UIColor.init(red: 203 / 255, green: 207 / 255, blue: 244 / 255, alpha: 1.0)
        case .whiteSnow:
            return UIColor.init(red: 246 / 255, green: 248 / 255, blue: 252 / 255, alpha: 1.0)
        case .pink:
            return UIColor.init(red: 227 / 255, green: 109 / 255, blue: 137 / 255, alpha: 1.0)
        case .lightPink:
            return UIColor.init(red: 250 / 255, green: 225 / 255, blue: 231 / 255, alpha: 1.0)
        }
    }
    
}

