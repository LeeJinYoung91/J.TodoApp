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
    
    let realm = try! Realm()
    private var testCount: Int = 0
    
    var SearchList: BehaviorRelay<[TodoDataModel]> {
        return searchModelList
    }
    
    override init() {
        super.init()
        self.createContainerWithData()
    }
    
    private func createContainerWithData() {
        let result = realm.objects(TodoDataModel.self)
        searchDataList = getModelList(result: result)
        searchModelList.accept(searchDataList)
    }
    
    func getSearchResult(searchText: String) -> [TodoDataModel] {
        return getModelList(result: getResultFromDatabase(searchText: searchText))
    }
    
    private func getModelList(result: Results<TodoDataModel>) -> [TodoDataModel] {
        var list = [TodoDataModel]()
        for model in result {
            model.ModelData = BehaviorRelay(value: TodoDataModel.TodoData(title: model.title, content: model.content, registedDate: model.registedDate, imageData: model.ImageData))
            list.append(model)
        }
        return list
    }
    
    func removeSelectResult(searchText: String, index: Int, doneListener: (()-> Void)?) {
        let results = getResultFromDatabase(searchText: searchText)
        var rowCount = 0
        for model in results {
            if index == rowCount {
                try! realm.write {
                    realm.delete(model)
                    doneListener?()
                }
            }
            rowCount += 1
        }
    }
    
    private func getResultFromDatabase(searchText: String) -> Results<TodoDataModel> {
        var predicate = "title CONTAINS[c] \"\(searchText)\" || content CONTAINS[c] \"\(searchText)\""
        if searchText.isEmpty {
            predicate = "title like \"*\(searchText)*\" || content like \"*\(searchText)*\""
        }
        return realm.objects(TodoDataModel.self).filter(predicate)
    }
    
    func getResultFromDate(_ date: Date) -> [TodoDataModel] {
        let predicate = NSPredicate(format: "registedDate > %@ && registedDate < %@", date.dayBefore as NSDate, date.dayAfter as NSDate)
        let objectList = realm.objects(TodoDataModel.self).filter(predicate)
        var modelList = [TodoDataModel]()
        
        for object in objectList {
            let compareResult = Calendar.current.compare(date, to: object.registedDate, toGranularity: .day)
            if compareResult == .orderedSame {
                object.ModelData = BehaviorRelay(value: TodoDataModel.TodoData(title: object.title, content: object.content, registedDate: object.registedDate, imageData: object.ImageData))
                modelList.append(object)
            }
        }
        
        return modelList
    }
    
    func addData(_ data: TodoDataModel) {
        do {
            try realm.write {
                if realm.isEmpty {
                    realm.create(TodoDataModel.self, value: data, update: .all)
                } else {
                    realm.add(data)
                }
                
                searchDataList.append(data)
                searchModelList.accept(searchDataList)
            }
        } catch {
            return
        }
    }
}
