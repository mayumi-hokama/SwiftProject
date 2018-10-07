//
//  LoginViewModel.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import Foundation

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

protocol LoginViewModelInputs {
    func login()
}

protocol LoginViewModelOutputs: class {
    var isLoginProcess: ((Bool) -> ())? { get set }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    
    // MARK: - LoginViewModelType
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
    
    // MARK: - LoginViewModelInputs
    func login() {
        isLoginProcess?(true)
        // TODO: ログイン処理など
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isLoginProcess?(false)
        }
    }
    
    // MARK: - LoginViewModelOutputs
    var isLoginProcess: ((Bool) -> ())?
}
