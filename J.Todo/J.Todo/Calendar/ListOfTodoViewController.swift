//
//  ListOfTodoViewController.swift
//  J.Todo
//
//  Created by JinYoung Lee on 2019/12/19.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ListOfTodoViewController: BaseDataContainViewController {
    var SearchDate:Date?
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedIndexPath: IndexPath?
    private var TodoModelList = [TodoDataModel]()
    private var todoViewModelDisposable: Disposable?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegate()
        addLongTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        todoViewModelDisposable?.dispose()
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = getTitle()
    }
    
    private func getTitle() -> String {
        if let date = SearchDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToString = dateFormatter.string(from: date)
            return dateToString
        }
        return "List"
    }

    private func addDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addObserver() {
        todoViewModelDisposable = todoViewModel.SearchList.subscribe(onNext: { [weak self] (searchModels) in
            guard let date = self?.SearchDate else { return }
            self?.TodoModelList = self?.todoViewModel.getResultFromDate(date) ?? [TodoDataModel]()
            self?.tableView.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    private func addLongTapGesture() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPress(gesture:)))
        tableView.addGestureRecognizer(longTapGesture)
    }
    
    @objc private func longTapPress(gesture: UILongPressGestureRecognizer) {
        let indexPath = tableView.indexPathForRow(at: gesture.location(in: tableView))
        guard let selectedItemIndexPath = indexPath else { return }
        selectedIndexPath = selectedItemIndexPath
        if gesture.state == .began {
            createMenuAlert()
        }
    }
    
    private func createMenuAlert() {
        let alertController = UIAlertController()
        alertController.title = "Memo"
        
        let updateAction = UIAlertAction(title: "Update", style: .destructive, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: "segue_showDetail", sender: strongSelf.TodoModelList[strongSelf.selectedIndexPath!.row])
        })
        let closeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(updateAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? TodoDetailViewController, let item = sender as? TodoDataModel else { return }
        detailViewController.setUpWithModel(item)
    }
}

extension ListOfTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let todoCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? SelectedTodoListCell {
            todoCell.title.text = TodoModelList[indexPath.row].title
            todoCell.content.text = TodoModelList[indexPath.row].content
            cell = todoCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoModelList.count
    }
}
