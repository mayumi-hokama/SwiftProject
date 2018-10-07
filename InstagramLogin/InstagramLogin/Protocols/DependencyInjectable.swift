//
//  DependencyInjectable.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import Foundation

protocol DependencyInjectable {
    associatedtype Dependency
    init(with dependency: Dependency)
}
