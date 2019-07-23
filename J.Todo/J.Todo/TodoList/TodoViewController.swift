//
//  ViewController.swift
//  J.RxSwift
//
//  Created by JinYoung Lee on 25/10/2018.
//  Copyright © 2018 JinYoung Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodoViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchedTargetCharacter:String?
    private let disposeComposite = CompositeDisposable()
    private var tapClear:Bool = false
    
    private var todoViewModel: TodoViewModel = TodoViewModel()
    private var searchCharacter: String = ""
    private var textFieldDisposable: Disposable?
    private var todoViewModelDisposable: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegate()
        todoViewModelDisposable = todoViewModel.SearchList.subscribe(onNext: { [weak self] (searchModels) in
            self?.tableView.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        todoViewModel.createContainerWithData()
        
        textFieldDisposable =
            searchBar.rx.text.orEmpty.subscribe(onNext: { [weak self] (query) in
                self?.searchCharacter = query
                self?.tableView.reloadData()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textFieldDisposable?.dispose()
        todoViewModelDisposable?.dispose()
    }
    
    private func addDelegate() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func testAddData(_ sender: Any) {
        if let alert: AddTodoListView = Bundle.main.loadNibNamed("AddTodoListView", owner: self, options: nil)?.first as? AddTodoListView {
            alert.present(nil)
            alert.DataListener = getModelData(model:)
        }
    }
    
    func getModelData(model: TodoDataModel) {
        todoViewModel.addData(model)
    }
}

//MARK:- Delegate For TableView
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "id_resultCell", for: indexPath) as! ResultTableCell
        cell.bindData(data: todoViewModel.getSearchResult(searchText: searchCharacter)[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoViewModel.getSearchResult(searchText: searchCharacter).count
    }
}

//MARK:- Delegate For SearchBar
extension TodoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        tapClear = text.isEmpty
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if tapClear && searchText.isEmpty {
            searchCharacter = ""
            tableView.reloadData()
        }
        
        tapClear = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
