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
import RealmSwift

class TodoDataModel: Object {
    struct Data {
        var title: String?
        var content: String?
        
        init(title: String?, content: String?) {
            self.title = title
            self.content = content
        }
    }

    var ModelData: BehaviorRelay<Data> = BehaviorRelay(value: Data(title: nil, content: nil))
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    
    convenience override init(value: Any) {
        self.init()
        if let dictionary = value as? [String:String] {
            ModelData = BehaviorRelay(value: Data(title: dictionary.first?.key, content: dictionary.first?.value))
            title = ModelData.value.title ?? ""
            content = ModelData.value.content ?? ""
        }
    }
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    func setTitle(title: String) {
        ModelData = BehaviorRelay(value: Data(title: title, content: ModelData.value.content))
        self.title = title
    }
    
    func setContent(content: String) {
        ModelData = BehaviorRelay(value: Data(title: ModelData.value.title, content: content))
        self.content = content
    }
}
