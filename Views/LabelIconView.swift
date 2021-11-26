//
//  LabelIconView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 10.11.2021.
//

import UIKit

class LabelIconView: UIView {
    let label = UILabel()
    let imageView = UIImageView()

    init(text: String, iconName: String) {
        super.init(frame: .zero)

        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        prepare()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepare() {
        addSubview(imageView)
        imageView.image = UIImage(systemName: "tag.fill")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(label)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = .systemFont(ofSize: 12, weight: .regular)
        label.preferredMaxLayoutWidth = 170

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15)
        ])
    }
}
