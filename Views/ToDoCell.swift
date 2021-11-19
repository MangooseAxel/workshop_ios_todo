//
//  ToDoCell.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 22.10.2021.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    static let identifier = "toDoCell"
    let wrapper = UIView()
    var titleLabel = UILabel()
    var categoryLabel = ImageLabelView()
    var dateLabel = ImageLabelView()
    var descriptionLabel = UILabel()
    var chevron = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        prepareWrapper()
        prepareChevron()
        prepareTitle()
        prepareDescription()
        prepareCategory()
        prepareDate()
    }
    
    func prepareWrapper() {
        contentView.addSubview(wrapper)
        wrapper.backgroundColor = .white
        wrapper.layer.cornerRadius = 8
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapper.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.96),
            wrapper.heightAnchor.constraint(equalTo: heightAnchor),
            wrapper.centerXAnchor.constraint(equalTo: centerXAnchor),
            wrapper.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10)
        ])
    }
    
    func prepareChevron() {
        wrapper.addSubview(chevron)
        chevron.image = UIImage(systemName: "chevron.right")
        chevron.contentMode = .scaleAspectFit
        chevron.tintColor = .lightGray
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevron.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -15),
            chevron.heightAnchor.constraint(equalToConstant: 16),
            chevron.widthAnchor.constraint(equalToConstant: 16),
            chevron.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 20)
        ])
    }
    
    func prepareTitle() {
        wrapper.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font  = .systemFont(ofSize: 16, weight: .bold)
    
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 18),
            titleLabel.topAnchor.constraint(equalTo: chevron.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor)
        ])
    }
    
    func prepareDescription() {
        wrapper.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.adjustsFontSizeToFitWidth = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font  = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 18),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -40)
        ])
    }
    
    func prepareCategory() {
        wrapper.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 18),
            categoryLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 17),
            categoryLabel.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.3)
        ])
    }
    
    func prepareDate() {
        wrapper.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 40),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 17),
            dateLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -40)
        ])
    }
    
    func setup(todo: ToDo) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description ?? ""
        categoryLabel.setup(systemaName: "tag.fill", labelText: todo.category ?? "")
        dateLabel.setup(
            systemaName: "calendar",
            labelText: Date().toString(from: todo.date, toFormat: .short)
        )
    }
}
