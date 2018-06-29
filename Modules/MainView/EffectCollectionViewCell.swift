//
//  EffectCollectionViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class EffectCollectionViewCell: UICollectionViewCell {
    let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 5.0
        view.layer.borderColor = UIColor(white: 155.0/255.0, alpha: 0.5).cgColor
        return view
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ResetIcon"), for: .normal)
        return button
    }()
    
    let effectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        label.textColor = UIColor.white
        return label
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "TrashIcon"), for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EffectSliderTableViewCell.self, forCellReuseIdentifier: EffectCellType.effectSliderCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tableView    
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(mainView)
        mainView.addSubview(tableView)
        mainView.addSubview(resetButton)
        mainView.addSubview(effectLabel)
        mainView.addSubview(trashButton)        
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))
        }
        effectLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView).offset(20.0)
            make.centerX.equalTo(mainView)
        }
        resetButton.snp.makeConstraints { make in
            make.size.equalTo(44.0)
            make.centerY.equalTo(effectLabel)
            make.left.equalTo(mainView).offset(10.0)
        }
        trashButton.snp.makeConstraints { make in
            make.size.equalTo(44.0)
            make.centerY.equalTo(effectLabel)
            make.right.equalTo(mainView).offset(-10.0)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
    }
    
    func configure(effect: Effect) {
        effectLabel.text = effect.effectType.name
        mainView.backgroundColor = UIColor.colorForIndex(effect.effectType.rawValue)
    }
}
