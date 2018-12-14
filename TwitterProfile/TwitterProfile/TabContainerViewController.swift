//
//  TabContainerViewController.swift
//  TwitterProfile
//
//  Created by 外間麻友美 on 2018/12/14.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class TabContainerViewController: UIViewController {

    private var targetViewControllerLists: [UIViewController] = []

    private var pageViewController: UIPageViewController?
    // 現在のindex
    private var currentCategoryIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        // Do any additional setup after loading the view.
    }

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

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        for childVC in children {
            if let targetVC = childVC as? UIPageViewController {
                pageViewController = targetVC
            }
        }

        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
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
}
extension TabContainerViewController: UIPageViewControllerDelegate {

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
                if targetViewController.view.tag - currentCategoryIndex == -CategoryTabViewController.categoryList.count + 1 {
                    updateCategoryScrollTabPosition(isIncrement: true)

                    // Case2: UIPageViewControllerで表示する画面のインデックス値が右スワイプで 最大インデックス値 → 0
                } else if targetViewController.view.tag - currentCategoryIndex == CategoryTabViewController.categoryList.count - 1 {
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

extension TabContainerViewController: UIPageViewControllerDataSource {

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
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
