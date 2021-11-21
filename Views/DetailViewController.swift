//
//  DetailViewController.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var todo: ToDo!
    var titleView: SingleLineInputView!
    var dateView: DateInputView!
    var categoryView: SingleLineInputView!
    var descriptionView: MultiLineInputView!
    
    weak var delegate: ToDoDelegate?
    var activeTextField: UITextField? = nil
    var activeTextView: UITextView? = nil
    var createButton: UIButton? = nil
    var keyboardSize: CGRect? = nil
    
    init(todo: ToDo = ToDo(userId: 1, title: "", date: "", category: "", description: "", isCompleted: false)) {
        super.init(nibName: nil, bundle: nil)
        self.todo = todo
        setup()
        todo.id == nil ? prepareModal() : prepareDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        titleView = SingleLineInputView(label: "Title", value: todo.title)
        dateView = DateInputView(label: "Date", value: Date().toDate(dateISO8601String: todo.date))
        categoryView = SingleLineInputView(label: "Category", value: todo.category)
        descriptionView = MultiLineInputView(label: "Description", value: todo.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
         }

        let bottomOfTextField = descriptionView.convert(descriptionView.bounds, to: self.view).maxY;
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfTextField > topOfKeyboard {
            self.view.frame.origin.y = 0 - (bottomOfTextField - topOfKeyboard)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func prepare() {
        view.backgroundColor = .systemGray6
        prepareTitleView()
        prepareDateView()
        prepareCategoryView()
        prepareDescriptionView()
    }
    
    func prepareTitleView() {
        view.addSubview(titleView)
        titleView.backgroundColor = .white
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func prepareCategoryView() {
        view.addSubview(categoryView)
        categoryView.backgroundColor = .white
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.topAnchor.constraint(equalTo: dateView.bottomAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func prepareDateView() {
        view.addSubview(dateView)
        dateView.backgroundColor = .white
        dateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func prepareDescriptionView() {
        view.addSubview(descriptionView)
        descriptionView.backgroundColor = .white
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18)
        ])
    }
    
    func prepareDetail() {
        title = "Detail ukolu"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "trash.square"), style: .plain, target: self, action: #selector(deleteToDo)),
            UIBarButtonItem(
                image: UIImage(systemName: todo.isCompleted ? "checkmark.square" : "square"),
                style: .plain, target: self, action: #selector(changeStatus))
        ]
    }
    
    func prepareModal() {
        title = "Novy ukol"

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = UIColor(cgColor: .init(red: 237/255, green: 192/255, blue: 52/255, alpha: 1))
        view.layer.cornerRadius = 0.5 * view.bounds.size.width
        
        let imageView = UIImageView(frame: CGRect(x: 9, y: 9, width: 12, height: 12))
        let image = UIImage(systemName: "multiply")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.tintColor = .darkGray
        
        let button = UIButton(frame: view.bounds)
        button.addTarget(self, action: #selector(dismissMy), for: .touchDown)
        
        view.addSubview(imageView)
        view.addSubview(button)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        prepareCreateButton()
    }
    
    func prepareCreateButton() {
        createButton = UIButton()
        if let createButton = createButton {
            createButton.backgroundColor = UIColor.init(red: 0/255, green: 125/255, blue: 155/255, alpha: 1)
            createButton.layer.cornerRadius = 8
            createButton.layer.masksToBounds = false
            createButton.layer.shadowColor = UIColor.darkGray.cgColor
            createButton.layer.shadowOffset = CGSize(width: 1, height: 2.5)
            createButton.layer.shadowRadius = 3
            createButton.layer.shadowOpacity = 0.6
            
            createButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            createButton.imageView?.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
            createButton.tintColor = .white
            
            createButton.setTitle(" Vytvorit", for: .normal)
            createButton.titleLabel?.font = .systemFont(ofSize: 16)

            createButton.addTarget(nil, action: #selector(createToDo), for: .touchDown)
            
            view.addSubview(createButton)
            
            createButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                createButton.heightAnchor.constraint(equalToConstant: 45),
                createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92)
            ])
        }
    }
    
    
    
    @objc func createToDo() {
        let datepicker = dateView.textField.inputView?.subviews[0] as? UIDatePicker
        todo = ToDo(userId: 1,
                    title: titleView.textField.text ?? "",
                    date: Date().toString(from: datepicker?.date ?? Date(), toFormat: .iso8601),
                    category: categoryView.textField.text ?? "",
                    description: descriptionView.textView.text ?? "",
                    isCompleted: false)
        
        HttpWorker.shared.addToDo(todo: todo) { [weak self] result in
            switch result {
            case .success(let newTodo):
                DispatchQueue.main.async {
                    self?.delegate?.didCreateToDo(newTodo)
                    self?.dismissMy()
                }
            case .failure(let error): self?.handleFailure(error)
            }
        }
    }
    
    @objc func deleteToDo() {
        if let id = todo.id {
            HttpWorker.shared.deleteToDo(id: id) { [weak self] result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.delegate?.didDeleteToDo(self?.todo)
                        self?.dismissMy()
                    }
                case .failure(let error): self?.handleFailure(error)
                }
            }
        }
    }
    
    @objc func changeStatus() {
        HttpWorker.shared.changeStatus(todo: todo) { [weak self] result in
            switch result {
            case .success(let updatedTodo):
                DispatchQueue.main.async {
                    self?.delegate?.didUpdateToDoStatus(updatedTodo)
                    self?.dismissMy()
                }
            case .failure(let error): self?.handleFailure(error)
            }
        }
    }
    
    @objc func dismissMy() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func handleFailure(_ error: ErrorMessage) {
        DispatchQueue.main.async {
            let alertPopUp = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
            alertPopUp.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertPopUp, animated: true)
        }
    }
}
