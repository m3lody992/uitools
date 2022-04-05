//
//  RoundedButton.swift
//  
//
//  Created by Pepe Polenta on 03/07/2020.
//  Copyright © 2020 Pepe Polenta All rights reserved.
//

import UIKit

public class RoundedButton: UIButton {

    @IBInspectable public var fillColor: UIColor? = UITools.primaryColor {
        didSet {
            backgroundColor = fillColor
        }
    }
    
    private var onTap: (() -> Void)?
    
    public func onTap(completion: @escaping () -> Void) {
        self.onTap = completion
    }
    
    @objc func pressed() {
        onTap?()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }

    func commonInit() {
        backgroundColor = UITools.primaryColor
        setTitleColor(.white, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }

}
