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
import Realm
import RealmSwift

class TodoDataModel: Object {
    struct TodoData {
        var title: String?
        var content: String?
        var registedDate: Date?
        var imageData: Data?
        
        init(title: String?, content: String?, registedDate: Date?, imageData: Data? = nil) {
            self.title = title
            self.content = content
            self.registedDate = registedDate
            self.imageData = imageData
        }
        
        func getRegistedDate() -> String {
            let format = DateFormatter()
            format.dateFormat = "YYYY-MM-dd hh:mm"
            format.locale = Locale.current
            return format.string(from: registedDate!)
        }
    }

    var ModelData: BehaviorRelay<TodoData> = BehaviorRelay(value: TodoData(title: nil, content: nil, registedDate: nil))
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var registedDate: Date = Date()
    @objc dynamic private var imageData: Data?
    var ImageData: Data? {
        set {
            try? realm?.write {
                imageData = newValue
            }
            ModelData = BehaviorRelay(value: TodoData(title: ModelData.value.title, content: ModelData.value.content,
                                                      registedDate: registedDate, imageData: newValue))
        }
        get {
            return imageData
        }
    }
    
    var ID: String {
        return uuid
    }
    
    convenience init(data: (String, String, Date?)) {
        self.init(value: data)
        if let date = data.2 {
            registedDate = date
        }
        ModelData = BehaviorRelay(value: TodoData(title: data.0, content: data.1, registedDate: registedDate, imageData: imageData))
        title = ModelData.value.title ?? ""
        content = ModelData.value.content ?? ""
        imageData = nil
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    override static func indexedProperties() -> [String] {
        return ["registedDate"]
    }
    
    func updateData(data: TodoData) {
        try? realm?.write {
            if let titleValue = data.title {
                self.title = titleValue
            }
            
            if let contentValue = data.content {
                self.content = contentValue
            }
        }
        
        ModelData = BehaviorRelay(value: data)
    }
}
