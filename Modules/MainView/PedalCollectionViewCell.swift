//
//  EffectPickerTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class PedalCollectionViewCell: UICollectionViewCell {
    let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    let pedalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.adjustsFontSizeToFitWidth = true
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
        mainView.addSubview(pedalImageView)
        mainView.addSubview(contentLabel)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-5.0)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(5.0)
        }
        pedalImageView.snp.makeConstraints { make in
            make.width.equalTo(20.0)
            make.height.equalTo(26.0)
            make.left.equalTo(mainView).offset(15.0)
            make.centerY.equalTo(mainView)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(pedalImageView.snp.right).offset(15.0)
            make.centerY.equalTo(mainView)
        }
    }
    
    func configure(effect: Effect) {
        contentLabel.text = effect.effectType.name
        mainView.backgroundColor = UIColor.colorForIndex(effect.effectType.rawValue)
        pedalImageView.image = #imageLiteral(resourceName: "EffectPedal")
    }
}
