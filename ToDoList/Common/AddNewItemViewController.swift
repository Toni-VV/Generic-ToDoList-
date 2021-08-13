//
//  AddNewItemViewController.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit
import CoreData

protocol AddNewItemViewControllerDelegate: AnyObject {
    func saveNewItem(item: String)
}


final class AddNewItemViewController: UIViewController {
    
    weak var delegate: AddNewItemViewControllerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 16, weight: .bold)
        v.numberOfLines = 0
        v.text = "Add New"
        v.textColor = .darkGray
        return v
    }()
    
    private lazy var titleField: UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.borderStyle = .roundedRect
        v.placeholder = "Add new item"
        
        return v
    }()
    
    private lazy var saveButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Save", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .blue
        v.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        [titleLabel,titleField,saveButton].forEach { view.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    @objc private func didTapSaveButton() {
        guard let text = titleField.text, !text.isEmpty else {
            return
        }
        delegate?.saveNewItem(item: text)
        dismiss(animated: true)
    }
}
