//
//  PlaceUI.swift
//  
//
//  Created by Jaesung on 2019/11/24.
//

import Foundation

import UIKit

public enum Color {
    case purple
    case lightPurple
    case whiteSnow
    case pink
    case lightPink
}

class PlaceUI {
    public static func color(_ color: Color) -> UIColor {
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
    
    
    /**
     "🥰 Like"
     */
    public static func setupButton(_ button: UIButton, title: String, iconURL: String?) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color(.whiteSnow), for: .normal)
        button.backgroundColor = self.color(.purple)
        
        guard let url = iconURL else { return }
        
        if #available(iOS 13.0, *) {
            if let systemImage = UIImage(systemName: url) {
                button.setImage(systemImage, for: .normal)
                button.tintColor = self.color(.purple)
                
                return
            }
        }
        
        if let customImage = UIImage(named: url) {
            button.setImage(customImage, for: .normal)
            
            return
        }
    }
    
    
    
    public static func setupButton(_ button: UIButton, imageURL: String) {
        if #available(iOS 13.0, *) {
            if let systemImage = UIImage(systemName: imageURL) {
                button.setBackgroundImage(systemImage, for: .normal)
                button.tintColor = self.color(.purple)
                
                return
            }
        }
        button.setBackgroundImage(UIImage(named: imageURL), for: .normal)
    }
    
}

