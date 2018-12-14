//
//  CategoryViewCell.swift
//  TwitterProfile
//
//  Created by 外間麻友美 on 2018/12/14.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    static let cellName = "\(CategoryViewCell.self)"
    
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCategory(name: String) {
        categoryLabel.text = name
    }
}
