//
//  AddEffectViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

protocol ContentPickerDelegate: class {
    func effectTypeWasSelected(_ effectType: EffectType)
    func loopTypeWasSelected(_ loopType: LoopType)
    func contentPickerWasCancelled()
}

enum ContentPickerType {
    case effect
    case loop
}

class ContentPickerViewController: UIViewController {
    static let contentPickerTableViewCell = "contentTableViewCell"
    
    weak var delegate: ContentPickerDelegate?
    
    let contentPickerType: ContentPickerType
    
    init(contentPickerType aContentPickerType: ContentPickerType) {
        self.contentPickerType = aContentPickerType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContentPickerTableViewCell.self, forCellReuseIdentifier: ContentPickerViewController.contentPickerTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89, a: 0.3), for: .highlighted)
        button.backgroundColor = UIColor.rgb(r: 247, g: 248, b: 252)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(cancelButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appDarkGray
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(contentTableView)
        view.addSubview(cancelButton)
    }
    
    func setupConstraints() {
        contentTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(54.0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5.0)
            } else {
                make.bottom.equalTo(view).offset(-5.0)
            }
            make.left.equalTo(view).offset(5.0)
            make.right.equalTo(view).offset(-5.0)
        }
    }
    
    @objc func cancelButtonWasTapped() {
        delegate?.contentPickerWasCancelled()
    }
}

extension ContentPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentPickerType {
        case .effect: 
            return EffectType.count
        case .loop:
            return LoopType.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentPickerViewController.contentPickerTableViewCell) as! ContentPickerTableViewCell
        switch contentPickerType {
        case .effect:
            if let effectType = EffectType(rawValue: indexPath.row) {
                cell.configure(effectType: effectType)
            }
        case .loop:
            if let loopType = LoopType(rawValue: indexPath.row) {
                cell.configure(loopType: loopType)
            }
        }
        return cell
    }    
}

extension ContentPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentPickerType {
        case .effect:
            if let effectType = EffectType(rawValue: indexPath.row) {
                delegate?.effectTypeWasSelected(effectType)
            }
        case .loop:
            if let loopType = LoopType(rawValue: indexPath.row) {
                delegate?.loopTypeWasSelected(loopType)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}
