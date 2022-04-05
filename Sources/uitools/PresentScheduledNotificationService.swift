//
//  PresentNitificationService.swift
//  
//
//  Created by Pepe Polenta on 16/11/2020.
//  Copyright © 2020 Pepe Polenta. All rights reserved.
//

import UIKit

public struct NotificationInfo {

    let id = UUID().uuidString
    let title: String?
    let message: String?
    let imageURL: URL?
    let buttons: [AlertButtonOption]
    let completion: (() -> Void)? // Completion only executes on button press of .ok

    public init(title: String?, message: String?, imageURL: URL? = nil, buttons: [AlertButtonOption] = [.ok], completion: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.imageURL = imageURL
        self.buttons = buttons
        self.completion = completion
    }

}

public struct PresentScheduledNotificationService {

    private static var presentingViewController: BaseViewController? {
        UIApplication.getTopViewController() as? BaseViewController
    }

    private static var isPresenting = false
    private static var notificationAddedWhilePresenting = false

    private static var storedNotifications = [NotificationInfo]()

    // Used when not presenting imediately
    public static func addNotification(_ notification: NotificationInfo) {
        storedNotifications.append(notification)
    }

    // Used when presenting imediately, handles already presenting
    public static func addNotificationAndPresent(_ notification: NotificationInfo) {
        storedNotifications.append(notification)
        notificationAddedWhilePresenting = isPresenting
        if isPresenting == false {
            presentNotifications()
        }
    }

    public static func presentNotifications() {
        DispatchQueue.global(qos: .userInteractive).async {
            let semaphore = DispatchSemaphore(value: 0)
            isPresenting = true
            notificationAddedWhilePresenting = false
            for notification in storedNotifications {
                DispatchQueue.main.async {
                    presentAlert(withTitle: notification.title, andMessage: notification.message, imageURL: notification.imageURL, buttons: notification.buttons) {
                        notification.completion?()
                        semaphore.signal()
                    } onDismiss: {
                        semaphore.signal()
                    }
                    storedNotifications.removeAll(where: { $0.id == notification.id })
                }
                semaphore.wait()
            }

            if notificationAddedWhilePresenting {
                presentNotifications()
            } else {
                isPresenting = false
            }
        }
    }

    // Image URL is only for showing promotional app logo, rating is applied automatically. If we will need images without rating this should be updated.
    private static func presentAlert(withTitle title: String?, andMessage message: String?, imageURL: URL? = nil, buttons: [AlertButtonOption] = [.ok], onOk: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            if let imageURL = imageURL {
                alert.message = "\n\n\n\n\n\n" + (message ?? "") // "\n\n\n\n\n\n"

                // Add image view
                let widthAndHeight = 50
                let imageView = UIImageView(frame: CGRect(x: 135 - widthAndHeight / 2, y: 48, width: widthAndHeight, height: widthAndHeight))
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 6
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: imageURL)
                alert.view.addSubview(imageView)

                // Add rating label
                let labelWidth = 120
                let label = UILabel(frame: CGRect(x: 135 - labelWidth / 2, y: 104, width: labelWidth, height: 32))
                label.textAlignment = .center
                label.text = UITools.strings.fiveAsters // "⭐️⭐️⭐️⭐️⭐️"
                alert.view.addSubview(label)
            }

            for button in buttons {
                switch button {
                case .ok:
                    alert.addAction(.init(title: "OK", style: .default) { _ in onOk?() }) // OK
                case .cancel:
                    alert.addAction(.init(title: "Cancel", style: .default) { _ in // Cancel
                        onDismiss?()
                        alert.dismiss(animated: true, completion: nil)
                    })
                case .later:
                    alert.addAction(.init(title: "Later", style: .default) { _ in // Later
                        onDismiss?()
                        alert.dismiss(animated: true, completion: nil)
                    })
                case .okDismiss:
                    alert.addAction(.init(title: "OK", style: .default) { _ in // OK
                        onDismiss?()
                        alert.dismiss(animated: true, completion: nil)
                    })
                }
            }

            presentingViewController?.present(alert, animated: true, completion: nil)
        }
    }

}
