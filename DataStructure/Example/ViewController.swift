//
//  ViewController.swift
//  Example
//
//  Created by Iman Mosayyebi on 11/24/23.
//

import UIKit
import DataStructure

enum DataStructures: String, CaseIterable {
    case linkedList = "Linked List"
}

class BaseViewController: UIViewController {
    var safeArea: UILayoutGuide!
    override func viewDidLoad() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}

class ViewController: BaseViewController {
    
    private let tableView = UITableView()
    private var dataStructureList: [DataStructures] = DataStructures.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Data Structure List"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func dataStuctureSelected(selected: DataStructures) {
        switch selected {
        case .linkedList:
            gotoNextViewController(LinkkedListViewController())
            break
        }
    }
    
    private func gotoNextViewController(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataStructureList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = dataStructureList[indexPath.row].rawValue
      cell.selectionStyle = .none
    return cell
  }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataStuctureSelected(selected: dataStructureList[indexPath.row])
    }
}
