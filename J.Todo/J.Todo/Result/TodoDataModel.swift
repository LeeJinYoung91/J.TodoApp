//
//  SearchDataModel.swift
//  J.RxSwift
//
//  Created by JinYoung Lee on 25/10/2018.
//  Copyright © 2018 JinYoung Lee. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TodoDataModel: NSObject {
    struct Data {
        var title: String?
        var content: String?
        
        init(title: String?, content: String?) {
            self.title = title
            self.content = content
        }
    }

    var ModelData: BehaviorRelay<Data>?
    
    init(title:String, content:String?) {
        ModelData = BehaviorRelay(value: Data(title: title, content: content))
    }
    
    func setTitle(title: String) {
        ModelData = BehaviorRelay(value: Data(title: title, content: ModelData?.value.content))
    }
    
    func setContent(content: String) {
        ModelData = BehaviorRelay(value: Data(title: ModelData?.value.title, content: content))
    }
}
