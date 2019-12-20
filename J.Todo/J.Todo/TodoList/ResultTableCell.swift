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
    @IBOutlet weak var registedDate: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var seperator: UIView!
    
    let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 8
        seperator.layer.cornerRadius = 4
    }
    
    func bindData(data:TodoDataModel) {
        self.title.text = data.ModelData.value.title
        self.registedDate.text = data.ModelData.value.registedDate
        
    }
}
