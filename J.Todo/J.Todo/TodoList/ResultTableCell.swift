//
//  ResultTableCell.swift
//  J.RxSwift
//
//  Created by JinYoung Lee on 25/10/2018.
//  Copyright © 2018 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ResultTableCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var registedDate: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var seperator: UIView!
    @IBOutlet var dateTopToTitleConstraints: NSLayoutConstraint!
    @IBOutlet var dateTopToContentConstraints: NSLayoutConstraint!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 8
        seperator.layer.cornerRadius = 4
    }
    
    func bindData(data:TodoDataModel, cellIndex: IndexPath, expand: Bool) {
        title.text = data.ModelData.value.title
        registedDate.text = data.ModelData.value.getRegistedDate()
        content.text = data.ModelData.value.content
        
        guard let desc = content.text, !desc.isEmpty else {
            return
        }
        
        dateTopToTitleConstraints.priority = expand ? UILayoutPriority(250) : UILayoutPriority(1000)
    }
}
