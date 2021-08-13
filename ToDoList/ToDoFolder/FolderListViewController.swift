//
//  ViewController.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit

final class FolderListViewController: UIViewController {
    
    private lazy var tableView: GenericTableView<FolderTableViewCell,Folder> = {
        let sortD = [NSSortDescriptor(key: "title", ascending: true)]
        let dataProvider = DataProvider<Folder>(manageObjectContext: CoreDataManager.shared.managedObjectContext,
                                                sortDescriptors: sortD)
        let table = GenericTableView<FolderTableViewCell,Folder>(dataProvider: dataProvider) { (cell, model) in
            cell.model = model
        } selectionHandler: { [weak self] (folder) in
            guard let strongSelf = self, let folderTitle = folder.title else {
                return
            }
            let vc = ToDoListViewController(folder: folderTitle)
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
        return table
    }()
    
    
    private lazy var addNewButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        button.addTarget(self, action: #selector(didTapNewButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.performFetch()
    }
    
    private func setupView() {
        title = "My List"
        view.addSubview(tableView)
        view.addSubview(addNewButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        // tableView
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // add new button
        NSLayoutConstraint.activate([
            addNewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewButton.widthAnchor.constraint(equalToConstant: 44),
            addNewButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapNewButton() {
        let vc = AddNewItemViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension FolderListViewController: AddNewItemViewControllerDelegate {
    func saveNewItem(item: String) {
        CoreDataManager.shared.saveFolder(name: item)
        tableView.performFetch()
    }
    
    
}

