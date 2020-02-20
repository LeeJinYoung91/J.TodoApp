//
//  TodoListHeader.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2020/02/20.
//  Copyright © 2020 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class TodoListHeader: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    
    func setTitle(_ title: String) {
        titleLabel?.text = title
    }
}
