//
//  IndicatorButton.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

final class IndicatorButton: UIButton, ButtonIndicatable {
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        indicator.frame = CGRect(x: (self.frame.size.width - 20) / 2, y: (self.frame.size.height - 20) / 2, width: 20, height: 20)
        return indicator
    }()
}
