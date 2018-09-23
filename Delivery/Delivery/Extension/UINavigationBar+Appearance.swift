//
//  UINavigationBar+Appearance.swift
//  Delivery
//
//  Created by Joe on 23/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    static func setAppearance() {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.uicolorFromHex(rgbValue: 0xffffff)
        navigationBarAppearace.barTintColor = UIColor.uicolorFromHex(rgbValue: 0x29a5ee)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
}
