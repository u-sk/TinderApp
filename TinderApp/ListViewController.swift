//
//  ListViewController.swift
//  TinderApp
//
//  Created by 板垣有祐 on 2019/09/21.
//  Copyright © 2019 Yusuke Itagaki. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = likedName[indexPath.row]
        return cell
    }
    
}
