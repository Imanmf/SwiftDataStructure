//
//  LinkkedListViewController.swift
//  Example
//
//  Created by Iman Mosayyebi on 11/24/23.
//

import UIKit
import SnapKit
import DataStructure

class LinkkedListViewController: BaseViewController {
    
    var linkedList: LinkedList<String> = LinkedList<String>()
    
    private var rowStack: UIStackView {
        let stack = UIStackView()
        stack.axis  = .horizontal
        stack.distribution  = .fillEqually
        stack.alignment = .fill
        stack.spacing   = 16.0
        return stack
    }
    private var txtItems: [UITextView] = {
        var items: [UITextView] = []
        for i in 0...4 {
            let txt = UITextView()
            txt.textAlignment = .center
            txt.layer.cornerRadius = 6
            txt.layer.borderWidth = 1
            txt.layer.borderColor =  UIColor.lightGray.withAlphaComponent(0.4).cgColor
            items.append(txt)
        }
        return  items
    }()
    private lazy var btnSingleAdd: UIButton = {
        let button = UIButton()
        button.setTitle("Add single", for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            self?.singleAdd()
            self?.updateListData()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnArrayAdd: UIButton = {
        let button = UIButton()
        button.setTitle("Add array", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            self?.arrayAdd()
            self?.updateListData()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnClearList: UIButton = {
        let button = UIButton()
        button.setTitle("Clear List", for: .normal)
        button.setTitleColor(.red.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            self?.linkedList.clear()
            self?.lblAction.text = "Action: List cleared."
            self?.updateListData()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnGetFirst: UIButton = {
        let button = UIButton()
        button.setTitle("Get first", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            if let first = self?.linkedList.getFirst() {
                self?.lblAction.text = "Action: first node is \(first)"
            } else {
                self?.lblAction.text = "Action: get first node - list is  empty"
            }
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnGetLast: UIButton = {
        let button = UIButton()
        button.setTitle("Get last", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            if let last = self?.linkedList.getLast() {
                self?.lblAction.text = "Action: last node is \(last)"
            } else {
                self?.lblAction.text = "Action: get last node - list is  empty"
            }
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnPullFirst: UIButton = {
        let button = UIButton()
        button.setTitle("Remove first", for: .normal)
        button.setTitleColor(.orange.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            if let first = self?.linkedList.removeFirst() {
                self?.lblAction.text = "Action: first node deleted: \(first)"
            } else {
                self?.lblAction.text = "Action: remove first node - list is  empty"
            }
            self?.updateListData()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnPullLast: UIButton = {
        let button = UIButton()
        button.setTitle("Remove last", for: .normal)
        button.setTitleColor(.orange.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 6
        let action = UIAction { [weak self] _ in
            if let last = self?.linkedList.removeLast() {
                self?.lblAction.text = "Action: last node deleted: \(last)"
            } else {
                self?.lblAction.text = "Action: remove last node - list is  empty"
            }
            self?.updateListData()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    private var txtView: UITextView = {
        let txt = UITextView()
        txt.text = nil
        return txt
    }()
    private var lblAction: UILabel = {
        let lbl = UILabel()
        lbl.text = "Action: Linked List Demo Started."
        return lbl
    }()
    private var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.text = """
Please Fill blow text fields first.
Single add will add first element to list.
Array add will add all filled text fields to list.
"""
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Linked List"
        setupView()
        updateListData()
    }
    
    private func setupView() {
        // description
        view.addSubview(lblDescription)
        lblDescription.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        let txtStack = rowStack
        txtItems.forEach { item in
            txtStack.addArrangedSubview(item)
        }
        // text fields
        view.addSubview(txtStack)
        txtStack.snp.makeConstraints { make in
            make.top.equalTo(lblDescription.snp.bottom).offset(30)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.height.equalTo(30)
        }
        // add button views
        let btnStack = rowStack
        btnStack.addArrangedSubview(btnSingleAdd)
        btnStack.addArrangedSubview(btnArrayAdd)
        view.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.top.equalTo(txtStack.snp.bottom).offset(20)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
            make.height.equalTo(40)
        }
        // clear button
        view.addSubview(btnClearList)
        btnClearList.snp.makeConstraints { make in
            make.top.equalTo(btnStack.snp.bottom).offset(20)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
            make.height.equalTo(40)
        }
        //add get buttons
        let getStack = rowStack
        getStack.addArrangedSubview(btnGetFirst)
        getStack.addArrangedSubview(btnGetLast)
        view.addSubview(getStack)
        getStack.snp.makeConstraints { make in
            make.top.equalTo(btnClearList.snp.bottom).offset(20)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
            make.height.equalTo(40)
        }
        //add drop/pull/remove buttons
        let pullStack = rowStack
        pullStack.addArrangedSubview(btnPullFirst)
        pullStack.addArrangedSubview(btnPullLast)
        view.addSubview(pullStack)
        pullStack.snp.makeConstraints { make in
            make.top.equalTo(getStack.snp.bottom).offset(20)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
            make.height.equalTo(40)
        }
        // action label
        view.addSubview(lblAction)
        lblAction.snp.makeConstraints { make in
            make.top.equalTo(pullStack.snp.bottom).offset(50)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
            make.height.equalTo(40)
        }
        // text view
        view.addSubview(txtView)
        txtView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.top.equalTo(lblAction.snp.bottom).offset(20)
            make.left.equalTo(txtStack)
            make.right.equalTo(txtStack)
        }
    }
    
    private func singleAdd() {
        
        if let first = txtItems.first(where: {
            ($0.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines) != ""
        }) {
            let data = first.text!
            linkedList.add(data)
            lblAction.text = "Action: \(data) added to list."
            first.text = nil
        } else {
            lblAction.text = "Action: no data exist to add."
        }
    }
    
    private func arrayAdd() {
        let datas = txtItems.map {
            ($0.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }.filter { !($0 == "") }
        
        linkedList.addAll(datas)
        lblAction.text = "Action: \(datas) added to list."
        txtItems.forEach { txt in
            txt.text = nil
        }
    }
    
    private func updateListData() {
        txtView.text = String(describing: linkedList)
    }
}
