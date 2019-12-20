//
//  DateExtension.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2019/12/19.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return calendar.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return calendar.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return calendar.component(.month,  from: self)
    }
    
    var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
