//
//  UIButton.swift
// 
//
//  Created by Pepe Polenta on 07/10/2020.
//  Copyright © 2020 Pepe Polenta. All rights reserved.
//

import UIKit

public extension UIButton {
    
    public func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
    
}
