//
//  GenericTableView.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit
import CoreData

final class GenericTableView<Cell: UITableViewCell, Model: NSManagedObject>: UITableView, UITableViewDelegate {
    private var cellID = String(describing: Cell.self)
    private var cellConfig: (Cell,Model) -> Void
    private var selectionHandler: (Model) -> Void
    
    private var dataProvider: DataProvider<Model>
    
    private lazy var modelDataSource: DataSource<Cell,Model> = {
        return DataSource<Cell,Model>(cellID: cellID, dataProvider: dataProvider, cellConfig: cellConfig)
    }()
    
    init(dataProvider: DataProvider<Model>,
         cellConfig: @escaping (Cell,Model) -> Void,
         selectionHandler: @escaping (Model) -> Void) {
        
        self.dataProvider = dataProvider
        self.cellConfig = cellConfig
        self.selectionHandler = selectionHandler
        
        super.init(frame: .zero, style: .plain)
        
        self.dataSource = modelDataSource
        self.delegate = self
        self.register(Cell.self, forCellReuseIdentifier: cellID)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tableFooterView = UIView()
        self.modelDataSource.tableView = self
        performFetch()
    }
    
    func performFetch() {
        dataProvider.performFetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataProvider.objectAtIndex(at: indexPath)
        selectionHandler(model)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
