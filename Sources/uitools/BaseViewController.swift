//
//  BaseViewController.swift
//  
//
//  Created by Pepe Polenta on 08/07/2020.
//  Copyright © 2020 Pepe Polenta All rights reserved.
//

import UIKit
import Reachability
import JGProgressHUD

public enum AlertButtonOption: String {
    case cancel
    case later
    case okDismiss
    case ok
}

open class BaseViewController: UIViewController {

    public var exitButtonTags = [Int]()

    let reachability = try? Reachability()

    public var isLoading: Dynamic<Bool> = Dynamic(false)

    open var shouldShowAstersLabel: Bool {
        true
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupReachability()
    }

    func setupReachability() {
        reachability?.whenReachable = { reachability in

        }
        reachability?.whenUnreachable = { [weak self] _ in
            // "Connection Problems", "You are not connected to the internet."
            self?.presentAlert(withTitle: "Connection Problems", andMessage: "You are not connected to the internet.", buttons: [.okDismiss])
        }

        try? reachability?.startNotifier()
    }

    @objc public func getAsters() {
        tabBarController?.selectedIndex = 1
    }

    lazy var loader = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .dark : .light)

    public func showLoader(withText text: String? = nil, blockTouches: Bool = true) {
        DispatchQueue.main.async {
            self.isLoading.value = true
            self.loader.interactionType = blockTouches ? .blockAllTouches : .blockNoTouches
            self.loader.textLabel.text = text
            self.loader.show(in: self.view)
        }
    }

    public func dismissLoader(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.isLoading.value = false
            self.loader.dismiss(animated: animated)
            completion?()
        }
    }

    lazy var errorHUD = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .dark : .light)

    public func showErrorHUD(withText text: String? = nil) {
        DispatchQueue.main.async {
            self.errorHUD.textLabel.text = text
            self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            self.errorHUD.show(in: self.view)
            self.errorHUD.dismiss(afterDelay: 3.0)
        }
    }

    lazy var successHUD = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .dark : .light)

    public func showSuccessHUD(withText text: String? = nil) {
        DispatchQueue.main.async {
            self.successHUD.textLabel.text = text
            self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.successHUD.show(in: self.view)
            self.successHUD.dismiss(afterDelay: 3.0)
        }
    }

    public func presentAlert(withTitle title: String?, andMessage message: String?, imageURL: URL? = nil, buttons: [AlertButtonOption] = [.ok], onOk: (() -> Void)? = nil) {
        PresentScheduledNotificationService.addNotificationAndPresent(.init(title: title, message: message, imageURL: imageURL, buttons: buttons, completion: onOk))
    }

    public func presentAlert(withError error: Error) {
        // "Oops, something went wrong!"
        presentAlert(withTitle: "Oops, something went wrong!", andMessage: error.localizedDescription, buttons: [.cancel])
    }

    public func addExitButton(toView: UIView) {
        let exitButton = UIButton(type: .custom)
        exitButton.tintColor = UITools.primaryColor
        exitButton.backgroundColor = UIColor(red: 249 / 255, green: 246 / 255, blue: 239 / 255, alpha: 1.0)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.kf.setImage(with: UITools.xmarkURL, for: .normal, options: Processor.Options.pdfTemplate)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        exitButton.layer.cornerRadius = 16
        exitButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        exitButton.clipsToBounds = true

        let tag = Int.random(in: 0 ... 10000)
        exitButtonTags.append(tag)
        exitButton.tag = tag
        toView.addSubview(exitButton)
        toView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "[exitButton]-16-|", // "[exitButton]-16-|"
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["exitButton": exitButton])) // "exitButton"
        toView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-56-[exitButton]", //"V:|-56-[exitButton]"
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["exitButton": exitButton])) // "exitButton"
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }

    public func toggleExitButton(enabled: Bool) {
        for tag in exitButtonTags {
            if let foundExitButton = view.viewWithTag(tag) {
                foundExitButton.isUserInteractionEnabled = enabled
            }
        }
    }

    @objc public func exit() {
        dismiss(animated: true)
    }

}

extension BaseViewController: Instantiable {

    public static var storyboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle(for: self)) // "Main"
    }

}
