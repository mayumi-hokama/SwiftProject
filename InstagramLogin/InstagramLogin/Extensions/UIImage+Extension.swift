//
//  UIImage+Extension.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

extension UIImage {
    static func fromColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure()
            return UIImage()
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        return image
    }
}
