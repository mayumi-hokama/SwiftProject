//
//  ButtonIndicatable.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonIndicatable {
    var indicatorView: UIActivityIndicatorView { get }
    var buttonTitle: String? { get }
    func startIndicatorAnimation()
    func stopIndicatorAnimation()
}

extension ButtonIndicatable where Self: UIButton {
    
    var buttonTitle: String? {
        return self.titleLabel?.text
    }
    
    func startIndicatorAnimation() {
        self.addSubview(indicatorView)
        isEnabled = false
        self.setTitle("", for: .normal)
        indicatorView.startAnimating()
    }
    
    func stopIndicatorAnimation() {
        isEnabled = true
        self.setTitle(buttonTitle, for: .normal)
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
}
