//
//  ViewController.swift
//  TagLikeView
//
//  Created by 外間麻友美 on 2018/11/26.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Tag {
        let name: String
    }

    let tags = [Tag(name: "Swift"),Tag(name: "UIKit"), Tag(name: "UICollectionView"), Tag(name: "self sizing"), Tag(name: "iOS10位上"), Tag(name: "AutoLayout")]


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.invalidateLayout()
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        cell.contentView.backgroundColor = .black
        cell.contentView.layer.cornerRadius = 5
        if let label = cell.contentView.viewWithTag(1) as? UILabel {
            label.text = tags[indexPath.row].name
        }
        return cell
    }
}

class TagAlignLeftFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var attributesToReturn = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        for (index, attr) in attributes.enumerated() where attr.representedElementCategory == .cell {
            attributesToReturn[index] = layoutAttributesForItem(at: attr.indexPath) ?? UICollectionViewLayoutAttributes()
        }
        return attributesToReturn
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
            let viewWidth = collectionView?.frame.width else {
                return nil
        }

        let sectionInsetsLeft = sectionInset.left

        guard indexPath.item > 0 else {
            currentAttributes.frame.origin.x = sectionInsetsLeft
            return currentAttributes
        }

        let prevIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
        guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
            return nil
        }
        let validWidth = viewWidth - sectionInset.left - sectionInset.right
        let currentColumnRect = CGRect(x: sectionInsetsLeft, y: currentAttributes.frame.origin.y, width: validWidth, height: currentAttributes.frame.height)
        guard prevFrame.intersects(currentColumnRect) else {
            currentAttributes.frame.origin.x = sectionInsetsLeft
            return currentAttributes
        }

        let prevItemTailX = prevFrame.origin.x + prevFrame.width
        currentAttributes.frame.origin.x = prevItemTailX + minimumInteritemSpacing
        return currentAttributes
    }
}
