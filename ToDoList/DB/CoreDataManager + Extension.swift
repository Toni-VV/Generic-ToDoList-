//
//  CoreDataManager + Extension.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import Foundation
import CoreData

extension CoreDataManager {
     func saveFolder(name: String) {
        let folder = Folder(context: managedObjectContext)
        folder.title = name
        saveContext()
    }
    
     func saveToDo(folder: String, title: String) {
        let toDo = ToDo(context: managedObjectContext)
        toDo.folder = folder
        toDo.title = title
        saveContext()
    }
}
