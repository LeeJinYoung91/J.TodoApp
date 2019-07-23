//
//  SearchViewModel.swift
//  J.RxSwift
//
//  Created by JinYoung Lee on 22/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Realm
import RealmSwift

class TodoViewModel: NSObject {
    private var searchModelList = BehaviorRelay(value: [TodoDataModel]())
    private var searchDataList = [TodoDataModel]()
    
    private var testCount: Int = 0

    var SearchList: BehaviorRelay<[TodoDataModel]> {
        return searchModelList
    }

    func createContainerWithData() {
        let realm = try! Realm()
        let result = realm.objects(TodoDataModel.self)
        for model in result {
            model.ModelData = BehaviorRelay(value: TodoDataModel.Data(title: model.title, content: model.content))
            searchDataList.append(model)
        }
        
        searchModelList.accept(searchDataList)
    }
    
    func getSearchResult(searchText: String) -> [TodoDataModel] {
        return searchModelList.value.filter {
            if let title = $0.ModelData.value.title {
                return title.contains(searchText)
            }
            
            return false
        }   
    }
    
    func addData(_ data: TodoDataModel) {
        searchDataList.append(data)
        searchModelList.accept(searchDataList)
        
        let realm = try! Realm()
        try! realm.write {
            if realm.isEmpty {
                realm.create(TodoDataModel.self, value: data, update: .all)
            } else {
                realm.add(data)
            }
        }
    }
}
