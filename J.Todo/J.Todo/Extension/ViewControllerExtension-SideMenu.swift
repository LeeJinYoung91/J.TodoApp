//
//  ViewControllerExtension.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2019/12/20.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension UIViewController {
    func intializeSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "sideMenu") as? SideMenuNavigationController
        
        SideMenuManager.default.leftMenuNavigationController?.settings = sideMenuSetting
        SideMenuManager.default.leftMenuNavigationController?.navigationBar.isHidden = true
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)        
    }
    
    var LeftSideMenu: SideMenuNavigationController? {
        return SideMenuManager.default.leftMenuNavigationController
    }

    private var sideMenuSetting: SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.presentingScaleFactor = 0.8
        presentationStyle.menuScaleFactor = 1
        presentationStyle.presentingEndAlpha = 0.7

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = screenWidth * 0.75
        settings.blurEffectStyle = .none
        settings.dismissWhenBackgrounded = true

        return settings
    }
    
    @objc func presentLeftSideMenu() {
        guard let sideMenu = LeftSideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
}
