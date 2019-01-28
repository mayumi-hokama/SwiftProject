//
//  TabContainerViewController.swift
//  TwitterProfile
//
//  Created by 外間麻友美 on 2018/12/14.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class TabContainerViewController: UIViewController {
    //
    let minHeaderHeight = 44

    // タブで表示するVCを格納しておく変数
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerにあるpageViewControllerを格納する変数
    private var pageViewController: UIPageViewController?

    // 現在のpageViewのindex
    private var currentCategoryIndex: Int = 0

    // header部分のcontainer
    private lazy var profileContainerView: ProfileContainerView = {
        let container = ProfileContainerView()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        // autolayout
        scrollView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: -300).isActive = true
        container.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        addChild(containerView: container, viewController: profileVC)

        return container
    }()
    // カテゴリタブ部分のcontainer
    private lazy var categoryTabContainerView: CategoryTabContainerView = {
        let container = CategoryTabContainerView()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "CategoryTabViewController") as! CategoryTabViewController
        // autolayout
        scrollView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addChild(containerView: container, viewController: tabVC)
        return container
    }()
    // pageView部分のcontainer
    private lazy var pageContainerView: PageContainerView = {
        let container = PageContainerView()
        // autolayout
        scrollView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: categoryTabContainerView.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        container.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        return container
    }()

    private var categoryTabViewController: CategoryTabViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryTabViewController") as! CategoryTabViewController
        return categoryVC
    }()


    // outlet
    @IBOutlet weak var scrollView: CustomScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //layoutContentView()
        scrollView.contentSize = scrollView.frame.size
    }

    private func layoutContentView() {
        // TODO: 定数
        let minimumHeight:CGFloat  = 20
        let height: CGFloat = 300

        let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
        let relativeHeight  = -relativeYOffset;

        let frame = CGRect(x: 0, y: relativeYOffset, width: scrollView.frame.size.width, height: (relativeHeight > minimumHeight) ? relativeHeight : minimumHeight )

        profileContainerView.translatesAutoresizingMaskIntoConstraints = true
        profileContainerView.frame = frame

        categoryTabContainerView.layoutIfNeeded()
        pageContainerView.layoutIfNeeded()
        print(scrollView.frame.size)
        scrollView.contentSize = scrollView.frame.size

    }

    // タブ分のVCをPageVCへセット
    private func setupPageViewController() {
        // PageVCにセット
        let _ = CategoryTabViewController.categoryList.enumerated().map{ (index, categoryName) in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            switch index {
            case 0:
                let vc = sb.instantiateViewController(withIdentifier: "CompanyTopViewController") as! CompanyTopViewController
                vc.view.tag = index
                targetViewControllerLists.append(vc)
            case 1:
                let vc = sb.instantiateViewController(withIdentifier: "CompanyJobsViewController") as! CompanyJobsViewController
                vc.view.tag = index
                targetViewControllerLists.append(vc)
            default: break
            }
        }

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)

        addChild(containerView: pageContainerView, viewController: pageViewController!)
    }

    // 配置されているタブ表示のUICollectionViewの位置を更新する
    // MEMO: ContainerViewで配置しているViewControllerの親子関係を利用する
    private func updateCategoryScrollTabPosition(isIncrement: Bool) {
        for childVC in children {
            if let targetVC = childVC as? CategoryTabViewController {
                targetVC.moveToCategoryScrollTab(isIncrement: isIncrement)
            }
        }
    }

    func layoutChildViewController() {
        var frame = self.scrollView.frame
        frame.origin = .zero
        frame.size.height -= 100
        targetViewControllerLists[currentCategoryIndex].view.frame = frame
    }

    func addChild(containerView: UIView, viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

}
extension TabContainerViewController: UIPageViewControllerDelegate {

    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        // スワイプアニメーションが完了していない時には処理をさせなくする
//        if !completed { return }
//
//        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
//        if let targetViewControllers = pageViewController.viewControllers {
//            if let targetViewController = targetViewControllers.last {
//
//                // Case1: UIPageViewControllerで表示する画面のインデックス値が左スワイプで 0 → 最大インデックス値
//                if targetViewController.view.tag - currentCategoryIndex == -CategoryTabViewController.categoryList.count + 1 {
//                    updateCategoryScrollTabPosition(isIncrement: true)
//
//                    // Case2: UIPageViewControllerで表示する画面のインデックス値が右スワイプで 最大インデックス値 → 0
//                } else if targetViewController.view.tag - currentCategoryIndex == CategoryTabViewController.categoryList.count - 1 {
//                    updateCategoryScrollTabPosition(isIncrement: false)
//
//                    // Case3: UIPageViewControllerで表示する画面のインデックス値が +1
//                } else if targetViewController.view.tag - currentCategoryIndex > 0 {
//                    updateCategoryScrollTabPosition(isIncrement: true)
//
//                    // Case4: UIPageViewControllerで表示する画面のインデックス値が -1
//                } else if targetViewController.view.tag - currentCategoryIndex < 0 {
//                    updateCategoryScrollTabPosition(isIncrement: false)
//                }
//
//                // 受け取ったインデックス値を元にコンテンツ表示を更新する
//                currentCategoryIndex = targetViewController.view.tag
//            }
//        }
//    }
}

// MARK: - UIPageViewControllerDataSource

extension TabContainerViewController: UIPageViewControllerDataSource {

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        if index <= 0 {
            return targetViewControllerLists.last
        } else {
            return targetViewControllerLists[index - 1]
        }
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return targetViewControllerLists.first
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}
class TwitterScrollView: UIScrollView {

}
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
        //delegate = self
        // Scroll表示なし
        showsVerticalScrollIndicator = false
        bounces = true
        // TODO: headerの高さ分プラスしておく（本来は残したい最低ラインの高さ分引く）
        contentInset.top += 300

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
            if (diff == 0.0 || !isObserved) {
                return
            }

            print(object)
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

extension CustomScrollView: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        // 自分自身のscrollは無視する
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
class ProfileContainerView: UIView {
    override func willMove(toSuperview newSuperview: UIView?) {
        if let _ = self.superview as? UIScrollView {
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }

    override func didMoveToSuperview() {
        // TODO: Observer登録
        if let _ = self.superview as? UIScrollView {
            self.superview?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            // layout更新
            layoutContentView()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    private func layoutContentView() {
        if let scrollView = self.superview as? UIScrollView {
            //TODO: 定数
            let minimumHeight:CGFloat  = 20
            let height: CGFloat = 300

            let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
            let relativeHeight  = -relativeYOffset;

            let frame = CGRect(x: 0, y: relativeYOffset, width: scrollView.frame.size.width, height: (relativeHeight > minimumHeight) ? relativeHeight : minimumHeight )

            self.translatesAutoresizingMaskIntoConstraints = true
            self.frame = frame
        }
    }
}

class CategoryTabContainerView: UIView {
    override func willMove(toSuperview newSuperview: UIView?) {
        if let _ = self.superview as? UIScrollView {
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }

    override func didMoveToSuperview() {
        // TODO: Observer登録
        if let _ = self.superview as? UIScrollView {
            self.superview?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            // layout更新
            layoutContentView()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func layoutContentView() {
//        if let scrollView = self.superview as? UIScrollView {
//            //TODO: 定数
//            let minimumHeight:CGFloat  = 60
//            let height: CGFloat = 60
//
//            let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
//            let relativeHeight  = -relativeYOffset;
//
//            let frame = CGRect(x: 0, y: relativeYOffset, width: scrollView.frame.size.width, height: (relativeHeight > minimumHeight) ? relativeHeight : minimumHeight )
//
//            self.translatesAutoresizingMaskIntoConstraints = true
//            self.frame = frame
//        }
    }
}

class PageContainerView: UIView {}
