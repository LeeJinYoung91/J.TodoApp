//
//  Util.swift
//  J.Todo
//
//  Created by JinYoung Lee on 24/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class Util {
    static func createToastMessage(title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.title = title
        alertView.message = message
        
        alertView.view.layer.cornerRadius = 10
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                alertView.dismiss(animated: true, completion: nil)
            })
        })
    }
}
