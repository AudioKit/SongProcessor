//
//  AddEffectCollectionViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class AddEffectCollectionViewCell: UICollectionViewCell {
    let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont.boldSystemFont(ofSize: 72.0)
        label.textColor = UIColor.appDarkGray
        return label
    }()
    
    let tapToAddLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add an effect"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.appDarkGray
        return label
    }()
    
    let labelContainer = UIView()
    
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
        mainView.addSubview(labelContainer)
        labelContainer.addSubview(plusLabel)
        labelContainer.addSubview(tapToAddLabel)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))
        }
        labelContainer.snp.makeConstraints { make in
            make.center.equalTo(mainView)
            make.width.equalTo(mainView)
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
