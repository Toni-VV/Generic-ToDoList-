//
//  FolderTableViewCell.swift
//  ToDoList
//
//  Created by Антон on 06.07.2021.
//

import UIKit

final class FolderTableViewCell: UITableViewCell {
    
    var model: Folder? {
        didSet {
            if let folder = model {
                folderTitle.text = folder.title
            }
        }
    }
    
    private lazy var folderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        contentView.addSubview(folderTitle)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            folderTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            folderTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            folderTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            folderTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
}
