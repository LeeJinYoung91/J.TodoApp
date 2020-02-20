//
//  AddtodoListView.swift
//  J.Todo
//
//  Created by JinYoung Lee on 22/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class AddTodoListView: UIView {
    @IBOutlet weak var titleInputView: UITextField!
    @IBOutlet weak var contentInputView: UITextView!
    
    private final let widthMargin: CGFloat = 10
    private var backgroundDarkView: UIView?
    private var keyboardAppearance: Bool = false
    private final let colorPlaceHolder = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.8)
    private final let textViewInputColor = UIColor.white
    
    var DataListener: ((TodoDataModel) -> Void)?
    var SelectDate: Date? = Date()
    
    override func awakeFromNib() {
        addDelegate()
        setDefaultUI()
        setKeyboardAccessoryView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func addDelegate() {
        contentInputView.delegate = self
    }
    
    private func setDefaultUI() {
        frame = CGRect(x: widthMargin, y: screenHeight + addTodoAlertViewHeight, width: screenWidth - widthMargin*2, height: addTodoAlertViewHeight)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        titleInputView.placeholder = "Input Title"
        contentInputView.text = "Input Content"
        contentInputView.textColor = colorPlaceHolder
        contentInputView.selectedRange = NSRange(location: 0, length: 0)
    }
    
    private func setKeyboardAccessoryView() {
        let toolBarKeyboard = UIToolbar()
        let addTodoButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTodoList))
        let cancelAddListButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(closeKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarKeyboard.items = [flexibleSpace, cancelAddListButton, addTodoButton]
        toolBarKeyboard.tintColor = UIColor.magenta
        toolBarKeyboard.sizeToFit()
        titleInputView.inputAccessoryView = toolBarKeyboard
        contentInputView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc private func closeKeyboard() {
        titleInputView.endEditing(true)
        contentInputView.endEditing(true)
        keyboardAppearance = false
    }
    
    @objc private func addTodoList() {
        titleInputView.endEditing(true)
        contentInputView.endEditing(true)
        DataListener?(TodoDataModel(value: (titleInputView.text, contentInputView.text, SelectDate)))
        hide()
    }
    
    func present(_ doneListener: ((Bool)->Void)?) {
        backgroundDarkView = UIView(frame: screenBounds)
        backgroundDarkView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        backgroundDarkView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        screenRootViewController?.view.addSubview(backgroundDarkView ?? UIView(frame: screenBounds))
        screenRootViewController?.view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: (screenHeight + addTodoAlertViewHeight)/2 - self.safeAreaInsets.bottom)
        }, completion: doneListener)
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: screenHeight + addTodoAlertViewHeight)
        }, completion: { (success) in
            self.backgroundDarkView?.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if let userInfo = notification.userInfo {
            let safeAreaBottom: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            var targetFrame: CGRect = frame
            if endFrameY >= UIScreen.main.bounds.size.height {
                targetFrame = CGRect(x: targetFrame.origin.x, y: endFrameY - (targetFrame.height + safeAreaBottom), width: targetFrame.width, height: targetFrame.height)
                keyboardAppearance = false
            } else {
                if (keyboardAppearance) {
                    return
                }
                
                keyboardAppearance = true
                targetFrame = CGRect(x: targetFrame.origin.x, y: targetFrame.origin.y - endFrameY + safeAreaBottom * 2, width: targetFrame.width, height: targetFrame.height)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.frame = targetFrame
                            self.keyboardAppearance = true
            },completion: nil)
        }
    }
}

extension AddTodoListView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == colorPlaceHolder {
            textView.text = nil
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && text != "" {
            textView.text = nil
            textView.textColor = textViewInputColor
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Input Content"
            textView.textColor = colorPlaceHolder
            textView.selectedRange = NSRange(location: 0, length: 0)
        } else {
            textView.textColor = textViewInputColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.textColor == colorPlaceHolder {
            textView.text = "Input Content"
        }
    }
}
