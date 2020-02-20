//
//  TimePicker.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2020/02/20.
//  Copyright © 2020 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class TimePicker: UIView {
    @IBOutlet private weak var datePicker: UIDatePicker?
    private var backgroundDarkView: UIView?

    var SelectDate: Date?
    var SelectListener: ((Date) -> Void)?
    
    override func awakeFromNib() {
        datePicker?.setDate(Date(), animated: true)
    }
    
    func present() {
        backgroundDarkView = UIView(frame: screenBounds)
        backgroundDarkView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        backgroundDarkView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        screenRootViewController?.view.addSubview(backgroundDarkView ?? UIView(frame: screenBounds))
        screenRootViewController?.view.addSubview(self)
        
        backgroundDarkView?.alpha = 0
        alpha = 0
        frame.origin = CGPoint(x: 0 ,y: screenHeight/2)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backgroundDarkView?.alpha = 1
        }, completion: nil)
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.backgroundDarkView?.alpha = 0
        }, completion: { (success) in
            self.backgroundDarkView?.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    @IBAction func selectTime() {
        guard let selDate = SelectDate else { return }
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        if let date = datePicker?.date {
            let component = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            SelectListener?(Calendar.current.date(bySettingHour: component.hour!, minute: component.minute!, second: 0, of: selDate) ?? Date())
        }
        
        hide()
    }
}
