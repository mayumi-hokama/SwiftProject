//
//  ViewController.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var contentContainerView: ContentContainerView = {
        let container = ContentContainerView()
        scrollView.addSubview(container)
        addChild(containerView: container, viewController: contentPageViewController)
        return container
    }()

    private lazy var contentPageViewController: ContentPageViewController = {
        let vc = ContentPageViewController()
        vc.categoryDelegate = headerViewController
        return vc
    }()
    
    private let headerViewController = HeaderViewController()

    @IBOutlet weak var scrollView: CustomScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "StickyHeaderテスト"
        setupHeader()
    }

    private func setupHeader() {
        self.scrollView.stickyHeader.height = 300
        self.scrollView.stickyHeader.minimumHeight = 60
        self.scrollView.stickyHeader.view = headerViewController.view
        addChild(containerView: self.scrollView.stickyHeader.contentView, viewController: headerViewController)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Contentのサイズ調整
        scrollView.contentSize = scrollView.frame.size
        scrollView.stickyHeader.layoutContentView()
        layoutChildViewController()
    }

    func layoutChildViewController() {
        var frame = scrollView.frame
        frame.origin = .zero
        frame.size.height -= scrollView.stickyHeader.minimumHeight
        self.contentContainerView.frame = frame
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "minimumHeight" {
            layoutChildViewController()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {

    }
}

extension UIViewController {
    func addChild(containerView: UIView, viewController: UIViewController) {
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
