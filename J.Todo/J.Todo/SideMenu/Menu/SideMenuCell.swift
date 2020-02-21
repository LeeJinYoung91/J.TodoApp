//
//  SideMenuCell.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2020/02/21.
//  Copyright © 2020 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    
    func setTitle(_ title: String) {
        titleLabel?.text = title
    }
}
