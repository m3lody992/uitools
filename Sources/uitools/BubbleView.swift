//
//  BubbleView.swift
//  
//
//  Created by Pepe Polenta on 30/03/2021.
//  Copyright © 2021 Pepe Polenta. All rights reserved.
//

import UIKit

public class BubbleView: UIView {

    private var textLabel = UILabel()

    public func setText(_ text: String) {
        textLabel.text = text
    }

    public func setColor(_ color: UIColor) {
        backgroundColor = color
    }

    public func toggle(hide: Bool) {
        if hide {
            isHidden = true
            heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            isHidden = false
            heightAnchor.constraint(equalToConstant: 32).isActive = true
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        layer.cornerRadius = 6
        // Remove existing views
        if let existingBoxView = subviews.first(where: { $0.tag == 1337 }) {
            existingBoxView.removeFromSuperview()
        }
        // Set new view
        let boxView = UIView(frame: .init(x: frame.width / 4, y: 10, width: 30, height: 30))
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.tag = 1337
        insertSubview(boxView, at: 0)
        boxView.transform = .init(rotationAngle: .pi / 4)
        boxView.backgroundColor = backgroundColor
    }

}
