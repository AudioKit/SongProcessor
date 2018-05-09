//
//  AddEffectViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

protocol EffectPickerDelegate: class {
    func effectWasSelected(_ effect: Effect)
    
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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
}

extension EffectPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EffectType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "effectPickerTableViewCell") as! EffectPickerTableViewCell
        if let effectType = EffectType(rawValue: indexPath.item) {
            cell.configure(effectType: effectType)
        }
        return cell
    }    
}

extension EffectPickerViewController: UITableViewDelegate {
    
}
