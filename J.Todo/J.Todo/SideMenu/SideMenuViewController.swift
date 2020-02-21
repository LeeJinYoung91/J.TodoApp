//
//  SideMenuViewController.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2020/02/21.
//  Copyright © 2020 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var menuTableView: UITableView?
    private let menuList: [String] = ["Option", "Blah Blah...", "... ETC"]
    
    
    override func viewDidLoad() {
        menuTableView?.delegate = self
        menuTableView?.dataSource = self
    }
}

//MARK:- TableView Delate, Datasource
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_menuCell", for: indexPath) as! SideMenuCell
        cell.setTitle(menuList[indexPath.row])
        return cell
    }
    
    
}
