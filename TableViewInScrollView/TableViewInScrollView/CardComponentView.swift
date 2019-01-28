//
//  CardComponentView.swift
//  TableViewInScrollView
//
//  Created by 外間麻友美 on 2019/01/27.
//  Copyright © 2019 外間麻友美. All rights reserved.
//

import UIKit

class CardComponentView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardComponentView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        layout(with: view)
    }

    private func layout(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func configure(data: ViewController.CellData) {
        imageView.image = data.image
        textLabel.text = data.label
    }
}
