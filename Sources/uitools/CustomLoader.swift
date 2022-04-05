//
//  CustomLoader.swift
// 
//
//  Created by Pepe Polenta on 05/08/2020.
//  Copyright © 2020 Pepe Polenta. All rights reserved.
//

import Kingfisher
import UIKit

public class CustomLoader: Indicator {
    
    public init() {}

    public func startAnimatingView() {
        view.isHidden = false
    }

    public func stopAnimatingView() {
        view.isHidden = true
    }

    public var view: IndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .large
        }
        view.startAnimating()
        return view
    }()
}
