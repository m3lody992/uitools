//
//  NibBackedView.swift
//
//
//  Created by Bojan Dimovski on 14/01/2020.
//
//            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//                    Version 2, December 2004
//
// Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
//
// Everyone is permitted to copy and distribute verbatim or modified
// copies of this license document, and changing it is allowed as long
// as the name is changed.
//
//            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//  0. You just DO WHAT THE FUCK YOU WANT TO.
//
//
import UIKit

/// A utility protocol for auto-magically loading of nib backed views.
/// In order to use the protocol, you need to conform your `UIView` subclass to it.
/// Also, make sure to set the class name in the nib.
///
/// - Important:
/// - When the view is loaded in **code**, then you have to set the class name for the **View** property.
/// - When the view is loaded in **a storyboard**, you have to set the class name in the **File's owner** property.
///
/// If the view is intended to be used in a storyboard, you'll need to create an intermediate view which will contain the nib content.
/// The following sample should be used only as a basis.
/// ```
///    class FooView: UIView, NibBackedView {
///
///        private var contentView: UIView?
///
///        required init?(coder aDecoder: NSCoder) {
///            super.init(coder: aDecoder)
///            configure()
///        }
///
///        override init(frame: CGRect) {
///            super.init(frame: frame)
///            configure()
///        }
///
///        private func configure() {
///            let view = loadFromNib(useInStoryboard: true)
///            view.frame = self.bounds
///            addSubview(view)
///            contentView = view
///        }
///
///    }
/// ```
public protocol NibBackedView: UIView {

    /// Returns the nib name, equal to the class name.
    static var nibName: String { get }

    /// Returns the nib from the current bundle.
    static var nib: UINib { get }

    /// Returns the reuse identifier, equal to the class name.
    static var reuseIdentifier: String { get }

    /// Returns the size of the view as set in the nib.
    /// - Note:
    /// When loading from nib, the size of the view is the one set in the actual nib.
    static var estimatedSize: CGSize { get }

    /// A shorthand method for loading the view from its associated nib for the current instance.
    /// - Parameter useInStoryboard: When used in a storyboard, the nib needs the **File's owner** set.
    /// - Important:
    /// - Intended for loading views both in code and storyboards.
    func loadFromNib(useInStoryboard: Bool) -> UIView

    /// A static method for loading the view from its associated nib.
    /// - Important:
    /// - Intended for loading views in code.
    static func loadFromNib() -> Self
}

// MARK: - Default protocol implementation
public extension NibBackedView {

    static var nibName: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: nibName, bundle: Bundle(for: self))
    }

    static var reuseIdentifier: String {
        nibName
    }

    func loadFromNib(useInStoryboard: Bool = false) -> UIView {
        // The owner needs to be passed only when we use the view from storyboards.
        Self.loadFromNib(owner: useInStoryboard ? self : nil)
    }

    static func loadFromNib() -> Self {
        // The owner should be nil for views loaded in code.
        loadFromNib(owner: nil)
    }

    /// Load a view from a nib safely or throw a fatal error in debug builds.
    /// - Parameters:
    ///   - owner: An owner object of the loaded view.
    private static func loadFromNib<T>(owner: Any?) -> T {
        // When a view is loaded from a nib and used in a storyboard, we need to pass the owner to the nib instantiating method.
        // If an instance cannot be loaded, it is usually due to configuration.
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? T
        else {
            let errorMessage = (owner != nil) ? "Check if the File's owner has been to set to \(nibName) in the nib itself." : "Check if the class of the root view has been set to \(nibName) in the nib itself."
            fatalError("Could not instantiate a view from \(nibName)! \(errorMessage)")
        }

        // Return the loaded view.
        return view
    }

    static var estimatedSize: CGSize {
        loadFromNib().bounds.size
    }

}

// MARK: - Table view cells
extension NibBackedView where Self: UITableViewCell {

    // MARK: - Dequeuing
    /// Returns a reusable cell of this class. Replaces the `UITableView.dequeueReusableCell(withIdentifier:for:)` method.
    /// - Parameters:
    ///   - tableView: The table view which should dequeue the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Note:
    /// Make sure the cell is registered for use in the passed table, use the `register(for:)` method.
    static func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as? Self
        else {
            fatalError("Could not dequeue a cell from \(nibName)! Check if the class name has been set in the nib itself.")
        }

        return cell
    }

    // MARK: - Table cell registration
    /// Registers this cell for use in the passed table view.
    /// - Parameter tableView: The table view which should register the cell.
    static func register(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

}

// MARK: - Table view header and footer views
extension NibBackedView where Self: UITableViewHeaderFooterView {

    // MARK: - Dequeuing
    /// Returns a reusable header or footer view of this class. Replaces the `UITableView.dequeueReusableHeaderFooterView(withIdentifier:)` method.
    /// - Parameter tableView: The table view which should dequeue the view.
    /// - Note:
    /// Make sure the cell is registered for use in the passed table, use the `registerHeaderFooter(for:)` method.
    static func dequeueHeaderFooterView(from tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: nibName) as? Self
        else {
            fatalError("Could not dequeue a header/footer view from \(nibName)! Check if the class name has been set in the nib itself.")
        }

        return cell
    }

    // MARK: - Table cell registration
    /// Registers this view for use in the passed table view as a header or footer.
    /// - Parameter tableView: The table view which should register the view.
    static func registerHeaderFooter(for tableView: UITableView) {
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

}

// MARK: - Collection view cells
extension NibBackedView where Self: UICollectionViewCell {

    // MARK: - Dequeuing
    /// Returns a reusable cell of this class. Replaces the `UICollectionView.dequeueReusableCell(withIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? Self
        else {
            fatalError("Could not dequeue a cell from \(nibName)! Check if the class name has been set in the nib itself.")
        }

        return cell
    }

    // MARK: - Collection cell registration
    /// Registers this cell for use in the passed collection view.
    /// - Parameter collectionView: The collection view which should register the cell.
    static func register(for collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
    }

}

// MARK: - Collection view reusable views
extension NibBackedView where Self: UICollectionReusableView {

    // MARK: - Dequeuing
    /// Returns a reusable header view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    static func dequeueHeader(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        dequeueSupplementaryView(from: collectionView, at: indexPath, of: UICollectionView.elementKindSectionHeader)
    }

    /// Returns a reusable footer view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    static func dequeueFooter(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        dequeueSupplementaryView(from: collectionView, at: indexPath, of: UICollectionView.elementKindSectionFooter)
    }

    /// Returns a reusable supplementary view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    ///   - kind: The kind of supplementary view to dequeue.
    private static func dequeueSupplementaryView(from collectionView: UICollectionView, at indexPath: IndexPath, of kind: String) -> Self {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nibName, for: indexPath) as? Self
        else {
            fatalError("Could not dequeue a supplementary view from \(nibName)! Check if the class name has been set in the nib itself.")
        }

        return cell
    }

    // MARK: - Reusable view registration
    /// Registers this view for use in the passed table view as a header.
    /// - Parameter collectionView: The collection view which should register the view.
    static func registerHeader(for collectionView: UICollectionView) {
        registerSupplementaryView(for: collectionView, of: UICollectionView.elementKindSectionHeader)
    }

    /// Registers this view for use in the passed table view as a header.
    /// - Parameter collectionView: The collection view which should register the view.
    static func registerFooter(for collectionView: UICollectionView) {
        registerSupplementaryView(for: collectionView, of: UICollectionView.elementKindSectionFooter)
    }

    /// Registers this view for use in the passed table view as a header or a footer.
    /// - Parameters:
    ///   - collectionView: The collection view which should register the view.
    ///   - kind: The kind of supplementary view to register.
    private static func registerSupplementaryView(for collectionView: UICollectionView, of kind: String) {
        collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: nibName)
    }

}
