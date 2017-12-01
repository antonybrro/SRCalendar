//
//  Colors.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/30/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum Calendar {
        enum Header {
            static var month: UIColor { return UIColor(hex: "A40066")! }
            static var monthWithOpacity: UIColor { return UIColor(hex: "A4006670")! }
            static var weekday: UIColor { return UIColor(hex: "A20067")! }
            static var weekdayWithOpacity: UIColor { return UIColor(hex: "A2006770")! }
        }
        
        enum Cell {
            static var workday: UIColor { return UIColor(hex: "000000")! }
            static var weekend: UIColor { return UIColor(hex: "A20067")! }
            static var workdayWithOpacity: UIColor { return UIColor(hex: "00000070")! }
            static var weekendWithOpacity: UIColor { return UIColor(hex: "A2006770")! }
        }
        
        static var selectedDate: (colors: [CGColor], locations: [NSNumber]) {
            return (colors: [UIColor(hex: "A20067")!.cgColor, UIColor(hex: "AA005E")!.cgColor, UIColor(hex: "CE0037")!.cgColor], locations:[0.1, 0.5, 1.5]) }
    }
    
    convenience init?(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
