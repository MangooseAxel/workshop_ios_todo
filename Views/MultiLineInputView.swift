//
//  MultiLineInputView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class MultiLineInputView: BaseDetailInputView {
    let textView = UITextView()

    init(label: String, value: String?) {
        super.init(label: label)
        update(value)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()
        prepareTextView()
    }

    func prepareTextView() {
        addSubview(textView)
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .darkGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: super.labelView.bottomAnchor, constant: 7),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            textView.bottomAnchor.constraint(equalTo: super.divider.topAnchor, constant: -20)
        ])
    }

    func update(_ value: String?) {
        textView.text = value ?? ""
    }
}
