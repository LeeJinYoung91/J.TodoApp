//
//  CalendarDateCell.swift
//  J.Todo
//
//  Created by JinYoung Lee on 02/08/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CalendarDateCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selBackgroundView: UIView!
    
    override func awakeFromNib() {
        selBackgroundView.layer.cornerRadius = selBackgroundView.bounds.width / 2
        selBackgroundView.layer.masksToBounds = true
        selBackgroundView.isHidden = true
    }
    
    func handleSelected(cellState: CellState) {
        selBackgroundView.isHidden = !cellState.isSelected
    }
    
    func handelTextColor(cellState: CellState) {
        dateLabel.textColor = (cellState.dateBelongsTo == DateOwner.thisMonth) ? UIColor.white : UIColor.lightGray
    }
}
