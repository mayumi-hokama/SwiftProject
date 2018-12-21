//
//  ContentViewController.swift
//  StickyHeader
//
//  Created by 外間麻友美 on 2018/12/17.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ContentViewController: UITableViewDelegate {}
extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = "tableView: \(indexPath.row)"
        return cell
    }
}

class ContentContainerView: UIView {
    
}
