//
//  ProfileViewController.swift
//  TwitterProfile
//
//  Created by 外間麻友美 on 2018/12/14.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let minimumHeight: CGFloat = 20.0
    let height: CGFloat = 300.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setObserver()
    }
    func setObserver() {
        if let parentVC = self.parent as? TabContainerViewController {
            parentVC.scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {

            if let scrollView = object as? UIScrollView {
                // frame位置更新
                layoutContentView(scrollView)
            }
        }

    }
    deinit {
        if let parentVC = self.parent as? TabContainerViewController {
            parentVC.scrollView.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    func layoutContentView(_ scrollView: UIScrollView) {
        let minimumHeight = (self.minimumHeight < self.height) ? self.minimumHeight : self.height
        let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - self.height
        let relativeHeight  = -relativeYOffset;

        let frame = CGRect(x: 0, y: relativeYOffset, width: scrollView.frame.size.width, height: (relativeHeight > minimumHeight) ? relativeHeight : minimumHeight )

        self.view.frame = frame

    }
}
