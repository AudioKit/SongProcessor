//
//  EffectCollectionViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class EffectCollectionViewCell: UICollectionViewCell {
    let effectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = UIColor.white
        return label
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
        addSubview(effectLabel)
    }
    
    func setupConstraints() {
        effectLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20.0)
            make.centerX.equalTo(self)
        }
    }
    
    func configure(effect: Effect) {
        effectLabel.text = effect.effectType.name
        backgroundColor = UIColor.effectColorForIndex(effect.effectType.rawValue)
    }
}
