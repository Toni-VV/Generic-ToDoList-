//
//  DataProvider.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import Foundation
import CoreData

protocol DataProviderDelegate: AnyObject {
    func didInsertItem(at indexPath: IndexPath)
    func didDeleteItem(at indexPath: IndexPath)
}

final class DataProvider<Model: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    weak var delegate: DataProviderDelegate?
    
    private var manageObjectContext: NSManagedObjectContext
    private var sortDescriptors: [NSSortDescriptor]
    private var predicate: NSPredicate?
    
    private lazy var request: NSFetchRequest<Model> = {
        let request = NSFetchRequest<Model>(entityName: String(describing: Model.self))
        request.sortDescriptors = sortDescriptors
        if let predicate = predicate {
            request.predicate = predicate
        }
        return request
    }()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Model> = {
        let fetchResultsController = NSFetchedResultsController<Model>(
                                                 fetchRequest: request,
                                                 managedObjectContext: manageObjectContext,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    init(manageObjectContext: NSManagedObjectContext,
         sortDescriptors: [NSSortDescriptor],
         predicate: NSPredicate? = nil ) {
        self.manageObjectContext = manageObjectContext
        self.sortDescriptors = sortDescriptors
        self.predicate = predicate
        
        super.init()
        performFetch()
    }
    //MARK: - Actions
    
    func performFetch() {
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func objectAtIndex(at indexPath: IndexPath) -> Model {
        return fetchResultsController.object(at: indexPath)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let item = objectAtIndex(at: indexPath)
        manageObjectContext.delete(item)
        
        do {
            try manageObjectContext.save()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func numberOfSections() -> Int {
        return fetchResultsController.sections?.count ?? 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            if let index = newIndexPath {
                delegate?.didInsertItem(at: index)
            } else if type == .delete {
                if let index = indexPath {
                    delegate?.didDeleteItem(at: index)
                }
            }
        }
    }
}
