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
        return view
    }()
    
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
        addSubview(mainView)
        mainView.addSubview(effectLabel)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0))
        }
        effectLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView).offset(20.0)
            make.centerX.equalTo(mainView)
        }
    }
    
    func configure(effect: Effect) {
        effectLabel.text = effect.effectType.name
        mainView.backgroundColor = UIColor.colorForIndex(effect.effectType.rawValue)
    }
}
