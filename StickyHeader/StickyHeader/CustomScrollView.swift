//
//  CustomScrollView.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {
    // UIScrollerView KVOを格納する変数
    private var keyValueObservations = [UIScrollView]()
    private var isObserved: Bool = true
    private var lock: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        delegate = self
        // Scroll表示なし
        showsVerticalScrollIndicator = false
        isDirectionalLockEnabled = false
        bounces = true
        self.panGestureRecognizer.cancelsTouchesInView = false

        // KVO
        addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        isObserved = true
    }
    // KVOでscrollのContentOffsetを監視
    private func addKVO(view: UIScrollView) {
        if !keyValueObservations.contains(view) {
            lock = (view.contentOffset.y > -view.contentInset.top)
            print("view.contentOffset.y:", view.contentOffset.y)
            print("contentInset.top:", view.contentInset.top)

            view.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
            keyValueObservations.append(view)
        }
    }

    private func removeKVO() {
        keyValueObservations.forEach { $0.removeObserver(self, forKeyPath: "contentOffset") }
        keyValueObservations.removeAll()
    }
    deinit {
        removeKVO()
    }

    func setContentOffset(view: UIScrollView, offset: CGPoint) {
        isObserved = false
        view.contentOffset = offset
        isObserved = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentOffset", let change = change {
            guard let old = (change[.oldKey] as? NSValue)?.cgPointValue,
                let new = (change[.newKey] as? NSValue)?.cgPointValue else {
                    fatalError("Undefined KVO key.")
            }

            print("old:", old)
            print("new:", new)

            let diff = old.y - new.y
            // diffがなければreturn
            print("isObserved", isObserved)
            if (diff == 0.0 || !isObserved) {
                return
            }

            print("object :", object)
            if object is CustomScrollView {

                //Adjust self scroll offset when scroll down
                if diff > 0, lock {
                    setContentOffset(view: self, offset: old)
                } else if contentOffset.y < -contentInset.top, !bounces {
                    setContentOffset(view: self, offset: CGPoint(x: contentOffset.x, y: -contentInset.top))
                } else if contentOffset.y > -100 {
                    setContentOffset(view: self, offset: CGPoint(x: contentOffset.x, y: -100))
                }
            } else {
                //Adjust the observed scrollview's content offset
                if let scrollView = object as? UIScrollView {
                    lock = scrollView.contentOffset.y > -scrollView.contentInset.top
                    //Manage scroll up
                    if contentOffset.y < -100, lock, diff < 0 {
                        setContentOffset(view: scrollView, offset: old)
                    }
                    //Disable bouncing when scroll down
                    if !lock, ((contentOffset.y > -contentInset.top) || bounces) {
                        setContentOffset(view: scrollView, offset: CGPoint(x: scrollView.contentOffset.x, y: -scrollView.contentInset.top))
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
extension CustomScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        // 自分自身のジェスチャは虫
        if otherGestureRecognizer.view == self {
            return false
        }

        // Pan以外のGestureは無視
        guard gestureRecognizer is UIPanGestureRecognizer else {
            return false
        }

        // 水平方向のscrollは無視
        if let velocity = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: self) {
            if (abs(velocity.x) > abs(velocity.y)) {
                return false
            }
        }

        // ScrollViewのpanのみを拾う
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }

        // UITableView
        if let _ = scrollView.superview as? UITableView {
            return false
        }
        // tableViewの場合は無視
        if String(describing: type(of: scrollView.superview)).contains("UITableViewCellContentView")  {
            return false
        }

        // scrollViewにaddObserverでcontentOffsetを監視
        addKVO(view: scrollView)

        return true
    }
}
extension CustomScrollView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        lock = false
        // removeKVO
        removeKVO()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            print("scrollViewDidEndDragging")
            lock = false
            removeKVO()
        }
    }
}
