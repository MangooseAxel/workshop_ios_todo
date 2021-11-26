//
//  ImageLabelView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 18.11.2021.
//

import UIKit

class ImageLabelView: UIView {
    let imageView = UIImageView()
    let label = UILabel()

    init() {
        super.init(frame: .zero)
        prepare()
    }

    func prepare() {
        prepareImage()
        prepareLabel()
    }

    func prepareLabel() {
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 3),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func prepareImage() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray2

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 13),
            imageView.widthAnchor.constraint(equalToConstant: 13)
        ])
    }

    func setup(systemaName: String, labelText: String) {
        imageView.image = UIImage(systemName: systemaName)
        label.text = labelText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
