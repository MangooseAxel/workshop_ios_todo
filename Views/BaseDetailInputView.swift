//
//  BaseDetailInputView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class BaseDetailInputView: UIView {
    var labelView: LabelView!
    let border = UIRectEdge()
    let divider = UIView()

    init(label: String) {
        super.init(frame: .zero)
        labelView = LabelView(label: label)
        prepare()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepare() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelView)
        addSubview(divider)
        divider.backgroundColor = UIColor.init(white: 0.5, alpha: 0.25)
        divider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
