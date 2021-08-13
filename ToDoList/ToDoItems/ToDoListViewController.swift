//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit
import CoreData

final class ToDoListViewController: UIViewController {
    
    var folder: String
    
    private lazy var tableView: GenericTableView<ToDoTableViewCell,ToDo> = {
        let sortD = [NSSortDescriptor(key: "title", ascending: true)]
        let predicate = NSPredicate(format: "folder == %@", folder)
        let dataProvider = DataProvider<ToDo>(manageObjectContext: CoreDataManager.shared.managedObjectContext,
                                              sortDescriptors: sortD)
        let v = GenericTableView<ToDoTableViewCell,ToDo>(dataProvider: dataProvider) { (cell, model) in
            cell.model = model
        } selectionHandler: { (toDo) in
            print(toDo.title ?? "selected")
        }

        return v
    }()
    
    init(folder: String) {
        self.folder = folder
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.performFetch()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        title = folder
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

}
