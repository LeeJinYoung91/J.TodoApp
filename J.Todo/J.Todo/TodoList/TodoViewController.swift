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

class TodoViewController: BaseDataContainViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: LongPressedEnableTableView!
    
    private var searchedTargetCharacter:String?
    private let disposeComposite = CompositeDisposable()
    private var tapClear:Bool = false
    
    private var searchCharacter: String = ""
    private var textFieldDisposable: Disposable?
    private var todoViewModelDisposable: Disposable?
    
    private var searchList: [TodoDataModel] = [TodoDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegate()
        addLongTapGesture()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserverable()
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
        tableView.estimatedSectionHeaderHeight = 60
    }
    
    private func addLongTapGesture() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPress(gesture:)))
        tableView.addGestureRecognizer(longTapGesture)
    }
    
    @objc private func longTapPress(gesture: UILongPressGestureRecognizer) {
        let indexPath = tableView.indexPathForRow(at: gesture.location(in: tableView))
        guard let selectedItemIndexPath = indexPath else { return }
        if gesture.state == .began {
            tableView.addPressedIndexPaths(selectedItemIndexPath)
            tableView.reloadRows(at: [selectedItemIndexPath], with: .automatic)
        }
    }
    
    private func addObserverable() {
        todoViewModelDisposable = todoViewModel.SearchList.subscribe(onNext: { [weak self] (searchModels) in
            self?.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        textFieldDisposable =
            searchBar.rx.text.orEmpty.subscribe(onNext: { [weak self] (query) in
                self?.searchCharacter = query
                self?.tableView.reloadData()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "ToDo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddData))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sideMenu"), style: .plain, target: self, action: #selector(presentLeftSideMenu))
    }
    
    @objc private func AddData() {
        if let alert: AddTodoListView = Bundle.main.loadNibNamed("AddTodoListView", owner: self, options: nil)?.first as? AddTodoListView {
            alert.present(nil)
            alert.DataListener = getModelData(model:)
        }
    }
    
    func getModelData(model: TodoDataModel) {
        todoViewModel.addData(model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == "segue_showDetail" {
            guard let detailViewController = segue.destination as? TodoDetailViewController else {
                return
            }
            
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            detailViewController.setUpWithModel(searchList[indexPath.row])
        }
    }
}

//MARK:- Delegate For TableView
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "id_resultCell", for: indexPath) as! ResultTableCell
        cell.bindData(data: searchList[indexPath.row], cellIndex: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchList = todoViewModel.getSearchResult(searchText: searchCharacter)
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoViewModel.removeSelectResult(searchText: searchCharacter, index: indexPath.row, doneListener: {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue_showDetail", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "id_header") as? TodoListHeader
        headerView?.setTitle("List")
        return headerView
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
        }
        
        tapClear = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

class LongPressedEnableTableView: UITableView {
    var indexPaths: [IndexPath] = [IndexPath]()
    func addPressedIndexPaths(_ indexPath: IndexPath) {
        if indexPaths.contains(indexPath) {
            indexPaths.removeAll { (path) -> Bool in
                return path == indexPath
            }
            return
        }
        
        indexPaths.append(indexPath)
    }
}
