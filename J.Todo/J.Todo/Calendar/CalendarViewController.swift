//
//  CalendarViewController.swift
//  J.Todo
//
//  Created by JinYoung Lee on 02/08/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import Realm
import RealmSwift
import RxSwift
import RxCocoa

class CalendarViewController: BaseDataContainViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    private final let showListSegueIdentifier = "showTodoListOnDay"
    let formatter = DateFormatter()
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalenderConfigureOption()
    }
            
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "Calendar"
    }
    
    private func setUpCalenderConfigureOption() {
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsVerticalScrollIndicator = false
        calendarView.scrollDirection = .vertical
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showListSegueIdentifier {
            if let todoListViewController = segue.destination as? ListOfTodoViewController, let selectDate = sender as? Date {
                todoListViewController.SearchDate = selectDate
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 01") ?? Date()
        
        let addYear = 1
        let addMonth = -1
        var dateComponenet = DateComponents()
        dateComponenet.year = addYear
        dateComponenet.month = addMonth
        
        let endDate = Calendar.current.date(byAdding: dateComponenet, to: startDate)
        return ConfigurationParameters(startDate: startDate, endDate: endDate!, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarDateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        guard initialize else {
            initialize = true
            return
        }
        selectCell(cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    private func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    private func selectCell(cellState: CellState) {
        if cellState.isSelected {
            performSegue(withIdentifier: showListSegueIdentifier, sender: cellState.date)
        }
    }
    
    private func handleCellTextColor(cell: CalendarDateCell, cellState: CellState) {
        cell.handelTextColor(cellState: cellState)
    }
    
    private func handleCellSelected(cell: CalendarDateCell, cellState: CellState) {
        cell.handleSelected(cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        formatter.dateFormat = "MMMM"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "calenderHeader", for: indexPath) as! CalendarHeader
        header.monthLabel.text = formatter.string(from: range.start)
        formatter.dateFormat = "yyyy"
        header.yearLabel.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 130)
    }
}
