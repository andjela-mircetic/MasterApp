//
//  UIStyleSwitcher.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import Foundation

enum UIStyle: String {
    case uikit
    case swiftui
}

class UIStyleSwitcher {
    private static let key = "UIStyleKey"

    static var currentStyle: UIStyle {
        get {
            let rawValue = UserDefaults.standard.string(forKey: key) ?? UIStyle.uikit.rawValue
            return UIStyle(rawValue: rawValue) ?? .uikit
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: key)
        }
    }
}
