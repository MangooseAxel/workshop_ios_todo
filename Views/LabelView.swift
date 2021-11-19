//
//  LabelView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class LabelView: UIView {
    var label = UILabel()
    
    init(label: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        prepare(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(_ labelTxt: String) {
        
        addSubview(label)
        label.text = labelTxt
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
