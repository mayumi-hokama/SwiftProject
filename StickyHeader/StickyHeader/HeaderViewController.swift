//
//  HeaderViewController.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class HeaderContainerView: UIView {

    var parent: StickyHeader?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let view = self.superview, view.isKind(of:UIScrollView.self), let parent = self.parent {
            view.removeObserver(parent, forKeyPath: "contentOffset", context: nil)
        }
    }

    override func didMoveToSuperview() {
        // Observer登録
        if let view = self.superview, view.isKind(of:UIScrollView.self), let parent = parent {
            view.addObserver(parent, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }

//    func layoutContentView() {
//        if let scrollView = self.superview as? UIScrollView {
//            //TODO: 定数
//            let minimumHeight:CGFloat  = 100
//            let height: CGFloat = 300
//
//            let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
//            let relativeHeight  = -relativeYOffset;
//
//            let frame = CGRect(x: 0, y: relativeYOffset, width: scrollView.frame.size.width, height: (relativeHeight > minimumHeight) ? relativeHeight : minimumHeight )
//
//            self.translatesAutoresizingMaskIntoConstraints = true
//            self.frame = frame
//        }
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentOffset" {
//            // layout更新
//            layoutContentView()
//        } else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
//    deinit {
//        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
//    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}
private var xoStickyHeaderKey: UInt8 = 0
extension UIScrollView {


    var stickyHeader: StickyHeader! {

        get {

            var header = objc_getAssociatedObject(self, &xoStickyHeaderKey) as? StickyHeader

            if header == nil {
                header = StickyHeader()
                header!.scrollView = self
                objc_setAssociatedObject(self, &xoStickyHeaderKey, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }

            return header!
        }

    }
}
