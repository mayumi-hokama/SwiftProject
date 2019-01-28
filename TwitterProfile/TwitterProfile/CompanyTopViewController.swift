//
//  CompanyTopViewController.swift
//  TwitterProfile
//
//  Created by 外間麻友美 on 2018/12/14.
//  Copyright © 2018 外間麻友美. All rights reserved.
//

import UIKit
class CompanyTopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension CompanyTopViewController: UITableViewDelegate {
}
extension CompanyTopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = "CompanyTopViewController." + String(indexPath.row)
        return cell
    }
}
