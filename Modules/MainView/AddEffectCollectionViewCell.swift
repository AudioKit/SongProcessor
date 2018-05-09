//
//  AddEffectCollectionViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class AddEffectCollectionViewCell: UICollectionViewCell {
    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont.boldSystemFont(ofSize: 72.0)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let tapToAddLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add an effect"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let labelContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
        backgroundColor = UIColor.rgb(r: 247, g: 248, b: 252)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(labelContainer)
        labelContainer.addSubview(plusLabel)
        labelContainer.addSubview(tapToAddLabel)
    }
    
    func setupConstraints() {
        labelContainer.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self)
        }
        plusLabel.snp.makeConstraints { make in
            make.top.equalTo(labelContainer)
            make.bottom.equalTo(tapToAddLabel.snp.top)
            make.centerX.equalTo(labelContainer)
        }
        tapToAddLabel.snp.makeConstraints { make in
            make.top.equalTo(plusLabel.snp.bottom)
            make.bottom.equalTo(labelContainer)
            make.centerX.equalTo(labelContainer)
        }
    }
}
