//
//  DataSource.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit
import CoreData

final class DataSource<Cell: UITableViewCell, Model: NSManagedObject>: NSObject, UITableViewDataSource {
    
    var cellID: String
    var dataProvider: DataProvider<Model>
    var tableView: UITableView?
    var cellConfig: (Cell,Model) -> ()
    
    init(cellID: String, dataProvider: DataProvider<Model>, cellConfig: @escaping (Cell,Model) -> () ) {
        self.cellID = cellID
        self.dataProvider = dataProvider
        self.cellConfig = cellConfig
        
        super.init()
        
        self.dataProvider.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataProvider.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProvider.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID,for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        let model = dataProvider.objectAtIndex(at: indexPath)
        cellConfig(cell,model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataProvider.deleteItem(at: indexPath)
            tableView.reloadData()
        }
    }
}

extension DataSource: DataProviderDelegate {
    func didInsertItem(at indexPath: IndexPath) {
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func didDeleteItem(at indexPath: IndexPath) {
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}
