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
    
    let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(data:TodoDataModel) {
        self.title.text = data.ModelData.value.title
        self.content.text = data.ModelData.value.content
    }
}
