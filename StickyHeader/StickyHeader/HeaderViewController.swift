//
//  HeaderViewController.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    static let categoryList = ["おはよう", "HELLO"]

    @IBOutlet weak var headerImageView: UIImageView!
    // 現在選択されているindex
    private var currentSelectIndex = 0

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: CategoryViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: CategoryViewCell.cellName)
            collectionView.showsHorizontalScrollIndicator = false
            // MEMO: タブ内のスクロール移動を許可する場合はtrueにし、許可しない場合はfalseとする
            collectionView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.itemSize = CGSize(width: (view.frame.width / CGFloat(HeaderViewController.categoryList.count)) - 20, height: 50)
    }
}
extension HeaderViewController: UICollectionViewDelegate {

}

extension HeaderViewController: PageViewUpdateDelegate {
    
    func moveToCategoryScrollTab(isIncrement: Bool = true) {
        print("呼ばれたよん")
//        // UIPageViewControllerのスワイプ方向を元に、更新するインデックスの値を設定する
//        var targetIndex = isIncrement ? currentSelectIndex + 1 : currentSelectIndex - 1
//
//        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMaxIndex)を超えた場合は補正をする
//        if targetIndex > targetCollectionViewCellMaxIndex {
//            targetIndex = targetCollectionViewCellMaxIndex - targetContentsMaxIndex
//            currentSelectIndex = targetCollectionViewCellMaxIndex
//        }
//
//        // 取りうるべきインデックスの値が閾値(targetCollectionViewCellMinIndex)を下回った場合は補正をする
//        if targetIndex < targetCollectionViewCellMinIndex {
//            targetIndex = targetCollectionViewCellMinIndex + targetContentsMaxIndex
//            currentSelectIndex = targetCollectionViewCellMinIndex
//        }
//
//        // 押下した場所のインデックス値を持っておく
//        currentSelectIndex = targetIndex
//        //print("コンテンツ表示側のインデックスを元にした現在のインデックス値:", currentSelectIndex)
//
//        // 変数(currentSelectIndex)を基準にして位置情報を更新する
//        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)
    }
}

extension HeaderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeaderViewController.categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.cellName, for: indexPath) as? CategoryViewCell {
            let targetIndex = indexPath.row % HeaderViewController.categoryList.count
            let isSelectedTab = (indexPath.row % HeaderViewController.categoryList.count == currentSelectIndex % HeaderViewController.categoryList.count)
            cell.setCategory(name: HeaderViewController.categoryList[targetIndex], isSelected: isSelectedTab)
            return cell
        }

        return UICollectionViewCell()
    }

    // 配置したUICollectionViewをスクロールが止まった際に実行される処理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロールが停止した際に見えているセルのインデックス値を格納して、真ん中にあるものを取得する
        // 参考: https://stackoverflow.com/questions/18649920/uicollectionview-current-visible-cell-index

        var visibleIndexPathList: [IndexPath] = []
        for cell in collectionView.visibleCells {
            if let visibleIndexPath = collectionView.indexPath(for: cell) {
                visibleIndexPathList.append(visibleIndexPath)
            }
        }
        let targetIndexPath = visibleIndexPathList[1]

        // ※この部分は厳密には不要ではあるがdelegeteで引き渡す必要があるので設定している
        let targetDirection = getCategoryScrollContentsDirection(selectedIndex: targetIndexPath.row)

        // 押下した場所のインデックス値を現在のインデックス値を格納している変数(currentSelectIndex)にセットする
        currentSelectIndex = targetIndexPath.row
        //print("スクロールが慣性で停止した時の中央インデックス値:", currentSelectIndex)

        // 変数(currentSelectIndex)を基準にして位置情報を更新する
        updateCategoryScrollTabCollectionViewPosition(withAnimated: true)

        // 算出した現在のインデックス値・動かす方向の値を元に、UIPageViewControllerで表示しているインデックスの画面へ遷移する
//        self.delegate?.moveToCategoryScrollContents(
//            selectedCollectionViewIndex: currentSelectIndex,
//            targetDirection: targetDirection,
//            withAnimated: false
//        )
    }

    private func getCategoryScrollContentsDirection(selectedIndex: Int) -> UIPageViewController.NavigationDirection {

        // (現在のインデックス値 - 引数で渡されたインデックス値)を元に方向を算出する
        if currentSelectIndex - selectedIndex > 0 {
            return UIPageViewController.NavigationDirection.reverse
        } else {
            return UIPageViewController.NavigationDirection.forward
        }
    }
    // 選択もしくはスクロールが止まるであろう位置にあるセルのインデックス値を元にUICollectionViewの位置を更新する
    private func updateCategoryScrollTabCollectionViewPosition(withAnimated: Bool = false) {

        // インデックス値に相当するタブを真ん中に表示させる
        let targetIndexPath = IndexPath(row: currentSelectIndex, section: 0)

        collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: withAnimated)
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
