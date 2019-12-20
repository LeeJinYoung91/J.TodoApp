//
//  ModelContainer.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2019/12/20.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation

class ModelContainer {
    private static var instance = ModelContainer()
    static var Instance: ModelContainer { return instance }
    
    var ViewModel: TodoViewModel = TodoViewModel()
    init() {
        ViewModel.createContainerWithData()
    }
}
