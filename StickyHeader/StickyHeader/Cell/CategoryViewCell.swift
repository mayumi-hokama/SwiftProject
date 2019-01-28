//
//  CategoryViewCell.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/21.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    static let cellName = "\(CategoryViewCell.self)"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCategory(name: String, isSelected: Bool) {
        categoryName.text = name
        categoryName.textColor = isSelected ? .red : .gray
    }
}
