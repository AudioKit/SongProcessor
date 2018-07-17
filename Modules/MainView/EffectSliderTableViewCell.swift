//
//  EffectSliderTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 6/28/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class EffectSliderTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor.white
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(slider)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(30.0)
            make.top.equalTo(contentView).offset(10.0)
        }
        slider.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(30.0)
            make.right.equalTo(contentView).offset(-30.0)
            make.top.equalTo(contentView).offset(40.0)
            make.height.equalTo(50.0)
        }
    }
    
    func configure(effectValue: EffectValue) {
        titleLabel.text = effectValue.type.name
        slider.minimumValue = Float(effectValue.min)
        slider.maximumValue = Float(effectValue.max)
        slider.value = Float(effectValue.value)
        print(effectValue.min)
        print(effectValue.value)
        print(effectValue.max)
        print("==")
    }
}
