//
//  UIView+Layout.swift
//  Delivery
//
//  Created by Joe on 15/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

extension UIView {
    
    func matchSuperView() {
        
        guard let superview = superview else { return }
        
        anchor(top: (anchor: superview.topAnchor, constant: 0.0),
               leading: (anchor: superview.leadingAnchor, constant: 0.0),
               bottom: (anchor: superview.bottomAnchor, constant: 0.0),
               trailing: (anchor: superview.trailingAnchor, constant: 0.0))

    }
    
    func anchor(top : (anchor: NSLayoutYAxisAnchor, constant: CGFloat)?,
                leading : (anchor: NSLayoutXAxisAnchor, constant: CGFloat)?,
                bottom : (anchor: NSLayoutYAxisAnchor, constant: CGFloat)?,
                trailing : (anchor: NSLayoutXAxisAnchor, constant: CGFloat)?,
                width : CGFloat = 0.0, height : CGFloat = 0.0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.activateConstraint(anchor: top.anchor, constant: top.constant)
        }
        
        if let leading = leading {
            self.leadingAnchor.activateConstraint(anchor: leading.anchor, constant: leading.constant)
        }
        
        if let bottom = bottom {
            self.bottomAnchor.activateConstraint(anchor: bottom.anchor, constant: -bottom.constant)
        }
        
        if let trailing = trailing {
            self.trailingAnchor.activateConstraint(anchor: trailing.anchor, constant: -trailing.constant)
        }
        
       //self.widthAnchor.activateConstraint(equalToConstant: width)
       //self.heightAnchor.activateConstraint(equalToConstant: height)
    }
}

extension NSLayoutAnchor {
    
    @objc func activateConstraint(anchor : NSLayoutAnchor<AnchorType>, constant : CGFloat = 0.0) {
        self.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    @objc func deActivateConstraint(anchor : NSLayoutAnchor<AnchorType>, constant : CGFloat = 0.0) {
        self.constraint(equalTo: anchor, constant: constant).isActive = false
    }
}

extension NSLayoutDimension {
    
    func activateConstraint(equalToConstant : CGFloat) {
        self.constraint(equalToConstant: equalToConstant).isActive = true
    }
}

extension NSLayoutConstraint {
    
    static func standardSpacing() -> CGFloat {
        
        return 16.0
    }
}
