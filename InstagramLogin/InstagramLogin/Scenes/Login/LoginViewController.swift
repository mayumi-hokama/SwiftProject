//
//  LoginViewController.swift
//  InstagramLogin
//
//  Created by 外間麻友美 on 2018/10/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, DependencyInjectable {

    typealias Dependency = LoginViewModelType
    
    init(with dependency: Dependency) {
        viewModel = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutputs()
    }
    
    // MARK: - private
    private let viewModel: LoginViewModelType
    @IBOutlet private weak var loginButton: IndicatorButton! {
        didSet {
            loginButton.setBackgroundImage(UIImage.fromColor(UIColor.blue), for: .normal)
            loginButton.setBackgroundImage(UIImage.fromColor(#colorLiteral(red: 0.8784313725, green: 0.9254901961, blue: 0.9725490196, alpha: 1)), for: .disabled)
            loginButton.layer.cornerRadius = 4.0
            loginButton.clipsToBounds = true
        }
    }
    
    @IBAction private func didTapLogin(_ sender: UIButton) {
        viewModel.inputs.login()
    }
    
    private func setupOutputs() {
        viewModel.outputs.isLoginProcess = { [weak self] isLogin in
            self?.view.isUserInteractionEnabled = !isLogin
            isLogin ? self?.loginButton.startIndicatorAnimation() : self?.loginButton.stopIndicatorAnimation()
        }
    }
}
