//
//  DetailViewController.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 05.11.2021.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var todo: ToDo!
    var titleView: SingleLineInputView!
    var dateView: DateInputView!
    var categoryView: SingleLineInputView!
    var descriptionView: MultiLineInputView!
    
    weak var delegate: ToDoDelegate?
    
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
    }
    
    func prepare() {
        prepareScrollView()
        prepareContentView()
        prepareTitleView()
        prepareDateView()
        prepareCategoryView()
        prepareDescriptionView()
    }
    
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func prepareContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
    }
    
    func prepareTitleView() {
        contentView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func prepareCategoryView() {
        contentView.addSubview(categoryView)
        
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryView.topAnchor.constraint(equalTo: dateView.bottomAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func prepareDateView() {
        contentView.addSubview(dateView)
        
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            dateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func prepareDescriptionView() {
        contentView.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func prepareDetail() {
        title = "Detail ukolu"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "trash.square"), style: .plain, target: self, action: #selector(deleteToDo)),
            UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: nil)
        ]
    }
    
    func prepareModal() {
        title = "Novy ukol"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "multiply.circle.fill"),
            style: .plain, target: self, action: #selector(dismissMy))
        navigationItem.rightBarButtonItem?.tintColor = .white
        prepareCreateButton()
    }
    
    func prepareCreateButton() {
        let button = UIButton()
        view.addSubview(button)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
        button.setTitle(" Vyvvorit", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = UIColor.init(red: 0/255, green: 125/255, blue: 155/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(createToDo), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92)
        ])
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
