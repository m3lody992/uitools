//
//  UIViewController+Instantiable.swift
//  
//
//  Created by Pepe Polenta on 07/07/2020.
//  Copyright © 2020 Pepe Polenta All rights reserved.
//

import UIKit

public protocol Instantiable where Self: UIViewController {

    /// Should return the storyboard the vc is located in.
    static var storyboard: UIStoryboard { get }

}

public extension Instantiable {

    /// Instantiates Self from storyboard.
    /// IMPORTANT: Storyboard identifier must match class name!
    static func buildInstance() -> Self {
        return instanceFrom(storyboard: storyboard)!
    }

}

// MARK: - UIViewController + Storyboard instantiation

fileprivate extension UIViewController {

    static func instanceFrom(storyboard: UIStoryboard, identifier: String? = nil) -> Self? {
        return instanceFrom(storyboard: storyboard, identifier: identifier, as: self)
    }

    static func instanceFrom<T>(storyboard: UIStoryboard, identifier: String? = nil, as type: T.Type) -> T? {
        return storyboard.instantiateViewController(withIdentifier: identifier ?? "\(type)") as? T
    }

}
