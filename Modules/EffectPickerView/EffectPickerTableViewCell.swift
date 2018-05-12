//
//  EffectPickerTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class EffectPickerTableViewCell: UITableViewCell {
    let pedalImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "EffectPedal"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let effectLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(pedalImageView)
        contentView.addSubview(effectLabel)
    }
    
    func setupConstraints() {
        pedalImageView.snp.makeConstraints { make in
            make.width.equalTo(20.0)
            make.height.equalTo(26.0)
            make.left.equalTo(contentView).offset(15.0)
            make.centerY.equalTo(contentView)
        }
        effectLabel.snp.makeConstraints { make in
            make.left.equalTo(pedalImageView.snp.right).offset(15.0)
            make.centerY.equalTo(contentView)
        }
    }
    
    func configure(effectType: EffectType) {
        effectLabel.text = effectType.name
        backgroundColor = UIColor.effectColorForIndex(effectType.rawValue)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.7 : 1.0
    }
}
