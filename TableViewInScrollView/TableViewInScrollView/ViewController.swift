//
//  ViewController.swift
//  TableViewInScrollView
//
//  Created by 外間麻友美 on 2019/01/24.
//  Copyright © 2019 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct CellData {
        let image: UIImage?
        let label: String
    }

    var cells: [CellData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "CardComponentCell", bundle: nil), forCellReuseIdentifier: "CardComponentCell")
            tableView.rowHeight = UITableView.automaticDimension
            //tableView.isScrollEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        cells = [
            CellData(image: UIImage(named: "cat_1"), label: "テスト1"),
            CellData(image: UIImage(named: "cat_2"), label: "テスト2"),
            CellData(image: UIImage(named: "cat_3"), label: "テスト3")
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CardComponentCell") as! CardComponentCell
        cell.configure(data: cells)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

