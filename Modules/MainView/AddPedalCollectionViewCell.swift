//
//  EffectPickerTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class AddPedalCollectionViewCell: UICollectionViewCell {
    let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appDarkGray
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Add Effect";
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(mainView)
        mainView.addSubview(contentLabel)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-3.0)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(3.0)
        }
        contentLabel.snp.makeConstraints { make in
            make.center.equalTo(mainView)
        }
    }
    
    func configure(effect: Effect) {
        contentLabel.text = effect.effectType.name
        mainView.backgroundColor = UIColor.colorForIndex(effect.effectType.rawValue)
    }
    
    func configureAsAddButton() {
        contentLabel.text = "Add Effect"
    }
}
