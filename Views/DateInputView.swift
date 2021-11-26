//
//  DateInputView.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class DateInputView: SingleLineInputView {
    init(label: String, value: Date?) {
        super.init(label: label, value: Date().toString(from: value ?? Date()))
        textField.datePicker(date: value ?? Date(),
                             target: self,
                             changeAction: #selector(datePickerChanged(picker:)),
                             datePickerMode: .date)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ value: String?) {
        textField.text = value ?? ""
    }

    @objc
    func datePickerChanged(picker: UIDatePicker) {
        textField.text = Date().toString(from: picker.date)
    }
}

extension UITextField {
    func datePicker<T>(date: Date, target: T, changeAction: Selector, datePickerMode: UIDatePicker.Mode = .date) {
        let dateView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350))
        let datePicker = UIDatePicker()

        datePicker.date = date
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(target, action: changeAction, for: .valueChanged)

        dateView.addSubview(datePicker)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: 0.93).isActive = true

        self.inputView = dateView
    }
}
