//
//  BaseDataContainViewController.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2019/12/19.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class BaseDataContainViewController: UIViewController {
    internal var todoViewModel: TodoViewModel = ModelContainer.Instance.ViewModel
    internal var initialize: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    internal func setNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}
