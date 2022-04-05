//
//  UITableView.swift
// 
//
//  Created by Pepe Polenta on 16/06/2020.
//  Copyright © 2020 Pepe Polenta All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    func registerNib(for cellClass: AnyClass) {
        let name = String(describing: cellClass)
        register(UINib(nibName: name, bundle: Bundle(for: cellClass)), forCellWithReuseIdentifier: name)
    }
    
    func dequeueCell<T>(forIndexPath indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
}

public extension UITableView {

    func registerNib(for cellClass: AnyClass) {
        let name = String(describing: cellClass)
        register(UINib(nibName: name, bundle: Bundle(for: cellClass)), forCellReuseIdentifier: name)
    }

    func registerHeaderFooterNib(for headerFooterClass: AnyClass) {
        let name = String(describing: headerFooterClass)
        register(UINib(nibName: name, bundle: Bundle(for: headerFooterClass)), forHeaderFooterViewReuseIdentifier: name)
    }

    func registerHeaderFooterClass(_ headerFooterClass: AnyClass) {
        let name = String(describing: headerFooterClass)
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: name)
    }

    func dequeueHeaderFooterView<T>() -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T
    }

    func registerCellClass(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeueCell<T>() -> T? {
        dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T
    }

}
