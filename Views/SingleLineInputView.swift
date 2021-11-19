//
//  SingleLineInputViewController.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 04.11.2021.
//

import UIKit

class SingleLineInputView: BaseDetailInputView {
    let textField = UITextField()
    
    init(label: String, value: String?) {
        super.init(label: label)
        update(value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .darkGray
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: super.labelView.bottomAnchor, constant: 7),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            textField.bottomAnchor.constraint(equalTo: super.divider.topAnchor, constant: -15)
        ])
    }
    
    func update(_ value: String?) {
        textField.text = value ?? ""
    }
}
