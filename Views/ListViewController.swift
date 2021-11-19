//
//  ListViewController.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 21.10.2021.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var todosGrouped: [Int: [ToDo]] = [:]
    let navBarAppearence: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(red: 254/255, green: 203/255, blue: 0/255, alpha: 1)
        appearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        prepare()
    }
    
    func loadData() {
        HttpWorker.shared.getToDos() { [weak self] result in
            switch result {
            case .success(let results):
                self?.todosGrouped = self?.groupToDos(results) ?? [:]
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertPopUp = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
                    alertPopUp.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alertPopUp, animated: true)
                }
            }
        }
    }
    
    func groupToDos(_ todos: [ToDo]) -> [Int: [ToDo]] {
        return todos.reduce([Int:[ToDo]]()) { (res, todo) -> [Int:[ToDo]] in
            var res = res
            let index = todo.isCompleted ? 1 : 0
            res[index] = (res[index] ?? []) + [todo]
            return res
        }
    }
    
    func prepare() {
        prepareNavigationBar()
        prepareTable()
    }
    
    func prepareNavigationBar() {
        title = "Seznam ukolu"
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.backButtonTitle = "Zpet"
        navigationController?.navigationBar.tintColor = .white
    }
    
    func prepareTable() {
        view.addSubview(tableView)
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "toDoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 124
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -18),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 18),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 18)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosGrouped[section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todosGrouped.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoCell
        cell.setup(todo: todosGrouped[indexPath.section]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSectionHeaderView(title: section == 0 ? "Planovano" : "Dokonceno")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(todo: todosGrouped[indexPath.section]![indexPath.row])
        detail.delegate = self
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    @objc func addTapped() {
        let detail = DetailViewController()
        detail.delegate = self
        
        let nav: UINavigationController = UINavigationController(rootViewController: detail)
        nav.navigationBar.standardAppearance = navBarAppearence
        nav.navigationBar.scrollEdgeAppearance = navBarAppearence
        nav.view.backgroundColor = .darkGray
        
        self.present(nav, animated: true)
    }
    
    func didCreateToDo(_ todo: ToDo) {
        self.loadData()
    }
    
    func didDeleteToDo(_ todo: ToDo?) {
        self.loadData()
    }
}
