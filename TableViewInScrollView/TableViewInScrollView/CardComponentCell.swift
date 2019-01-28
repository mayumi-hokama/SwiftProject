//
//  CardComponentCell.swift
//  TableViewInScrollView
//
//  Created by 外間麻友美 on 2019/01/27.
//  Copyright © 2019 外間麻友美. All rights reserved.
//

import UIKit

class CardComponentCell: UITableViewCell {

    private lazy var scrollView: UIScrollView! = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var stackView: UIStackView! = {
        let view = UIStackView()
        return view
    }()

    var data: [ViewController.CellData] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let width: CGFloat = 200
//        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
//        let frame = scrollView.frame
//        self.scrollView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: (width * CGFloat(10)), height: frame.height)
//        self.scrollView.contentSize = CGSize(width: (width * CGFloat(10)), height: 200)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(data: [ViewController.CellData]) {
        self.data = data
        let width: CGFloat = 300
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        let frame = scrollView.frame
        self.scrollView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: UIScreen.main.bounds.width, height: 200)
        self.scrollView.contentSize = CGSize(width: (width * CGFloat(data.count)), height: 200)

        self.data.forEach { content in
            let component = CardComponentView()
            component.configure(data: content)
            stackView.addArrangedSubview(component)
            // TODO: Autolayout
            self.addConstraints(component: component)
        }
        self.contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: width * CGFloat(data.count), height: 200)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

    }
    private func setContentSize(data: [ViewController.CellData]) {
        let width: CGFloat = 300
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        let frame = scrollView.frame
        //self.scrollView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: (width * CGFloat(data.count)), height: frame.height)
        self.scrollView.contentSize = CGSize(width: (width * CGFloat(data.count)), height: frame.height)
//        UIView.animate(withDuration: 0.25) { () -> Void in
//            //self.scrollView.contentSize = CGSize(width: (width * CGFloat(data.count)), height: 200)
//        }
    }
    private func addConstraints(component: UIView) {
        component.translatesAutoresizingMaskIntoConstraints = false
        component.widthAnchor.constraint(equalToConstant: 300).isActive = true
        component.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //setContentSize(data: data)
    }
}
