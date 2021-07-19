//
//  Extensions.swift
//  Game-2048
//
//  Created by Avinash on 17/07/21.
//

import UIKit

extension UIColor {
    static let square = UIColor(netHex: 0xBDAB94)
    static let s2 = UIColor(netHex: 0xEEFFF0)
    static let s4 = UIColor(netHex: 0xA3FFED)
    static let s8 = UIColor(netHex: 0x9BFFAB)
    static let s16 = UIColor(netHex: 0xD3FF7A)
    static let s32 = UIColor(netHex: 0x50FFB5)
    static let s64 = UIColor(netHex: 0x00FFFE)

    static let s128 = UIColor(netHex: 0x0DB2FF)
    static let s256 = UIColor(netHex: 0x0DB2FF)
    static let s512 = UIColor(netHex: 0x0DB2FF)
    static let s1024 = UIColor(netHex: 0x0DB2FF)
    static let s2048 = UIColor(netHex: 0x0DB2FF)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIFont {
    struct tile {
        static let x = UIFont(name: "Verdana-Bold", size: 25)
        static let x2 = UIFont(name: "Verdana-Bold", size: 30)
        static let x3 = UIFont(name: "Verdana-Bold", size: 35)
        static let x4 = UIFont(name: "Verdana-Bold", size: 40)
    }
}

extension Notification.Name {
    static let swipeAction = Notification.Name("swipeAction")
    static let updateBoard = Notification.Name("updateBoard")
}
