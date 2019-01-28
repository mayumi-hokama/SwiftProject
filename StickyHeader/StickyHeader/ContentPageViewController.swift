//
//  ContentViewController.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

protocol PageViewUpdateDelegate: class {
    func moveToCategoryScrollTab(isIncrement: Bool)
}

class ContentPageViewController: UIPageViewController {

    weak var categoryDelegate: PageViewUpdateDelegate?

    // 現在表示しているカテゴリのindex
    private var currentCategoryIndex: Int = 0

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var targetViewControllerLists: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupPageViewController()
    }
    // タブ分のVCをPageVCへセット
    private func setupPageViewController() {
        // PageVCにセット
        let _ = HeaderViewController.categoryList.enumerated().map{ (index, categoryName) in
            switch index {
            case 0:
                let vc = GoodMorningViewController()
                vc.view.tag = index
                targetViewControllerLists.append(vc)
            case 1:
                let vc = HelloViewController()
                vc.view.tag = index
                targetViewControllerLists.append(vc)
            default: break
            }
        }

        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }

    // 配置されているタブ表示のUICollectionViewの位置を更新する
    // MEMO: ContainerViewで配置しているViewControllerの親子関係を利用する
    private func updateCategoryScrollTabPosition(isIncrement: Bool) {
        // TODO: delegateかな
        categoryDelegate?.moveToCategoryScrollTab(isIncrement: isIncrement)
    }
}
extension ContentPageViewController: UIPageViewControllerDelegate {

    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                // Case1: UIPageViewControllerで表示する画面のインデックス値が左スワイプで 0 → 最大インデックス値
                if targetViewController.view.tag - currentCategoryIndex == -HeaderViewController.categoryList.count + 1 {
                    updateCategoryScrollTabPosition(isIncrement: true)

                    // Case2: UIPageViewControllerで表示する画面のインデックス値が右スワイプで 最大インデックス値 → 0
                } else if targetViewController.view.tag - currentCategoryIndex == HeaderViewController.categoryList.count - 1 {
                    updateCategoryScrollTabPosition(isIncrement: false)

                    // Case3: UIPageViewControllerで表示する画面のインデックス値が +1
                } else if targetViewController.view.tag - currentCategoryIndex > 0 {
                    updateCategoryScrollTabPosition(isIncrement: true)

                    // Case4: UIPageViewControllerで表示する画面のインデックス値が -1
                } else if targetViewController.view.tag - currentCategoryIndex < 0 {
                    updateCategoryScrollTabPosition(isIncrement: false)
                }

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                currentCategoryIndex = targetViewController.view.tag
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ContentPageViewController: UIPageViewControllerDataSource {

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


class ContentContainerView: UIView {
    
}
