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

class TodoViewModel: NSObject {
    private let dataList:[String:String] = ["RxSwift":"https://www.rxswift.com", "Rx":"Test", "RxPod":"Testing RxSwift \n MultiLineTest", "Swift":"https://www.swift.com", "Objective-C":"Much\nMore\nHell\nOhWoo", "Testing":"Testing Test Test Test Test Testing"]
    
    private var searchModelList = BehaviorRelay(value: [TodoDataModel]())
    private var searchDataList = [TodoDataModel]()
    
    private var testCount: Int = 0

    var SearchList: BehaviorRelay<[TodoDataModel]> {
        return searchModelList
    }

    func createContainerWithData() {
        for data in dataList {
            if !searchDataList.contains(where: {
                if let title = $0.ModelData?.value.title {
                    return title == data.key
                }
                return false
            }) {
                searchDataList.append(TodoDataModel(title: data.key, content: data.value))
            }
        }
        
        searchModelList.accept(searchDataList)
    }
    
    func getSearchResult(searchText: String) -> [TodoDataModel] {
        return searchModelList.value.filter {
            if let title = $0.ModelData?.value.title {
                return title.contains(searchText)
            }
            
            return false
        }
    }
    
    func addTempData() {
        searchDataList.append(TodoDataModel(title: "RxSwift\(testCount)", content: "RxSwift append test\(testCount)"))
        testCount += 1
        searchModelList.accept(searchDataList)
    }
}
