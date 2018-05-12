//
//  AddEffectViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

protocol EffectPickerDelegate: class {
    func effectTypeWasSelected(_ effectType: EffectType)
    func effectPickerWasCancelled()
}

class EffectPickerViewController: UIViewController {
    static let effectPickerTableViewCell = "effectTableViewCell"

    weak var delegate: EffectPickerDelegate?
    
    lazy var effectsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EffectPickerTableViewCell.self, forCellReuseIdentifier: EffectPickerViewController.effectPickerTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(effectsTableView)
    }
    
    func setupConstraints() {
        effectsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

extension EffectPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EffectType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EffectPickerViewController.effectPickerTableViewCell) as! EffectPickerTableViewCell
        if let effectType = EffectType(rawValue: indexPath.row) {
            cell.configure(effectType: effectType)
        }
        return cell
    }    
}

extension EffectPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let effectType = EffectType(rawValue: indexPath.row) {
            delegate?.effectTypeWasSelected(effectType)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
