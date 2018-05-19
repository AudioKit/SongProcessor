//
//  EffectPickerTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class ContentPickerTableViewCell: UITableViewCell {
    let pedalImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "EffectPedal"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let contentLabel: UILabel = {
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
        contentView.addSubview(contentLabel)
    }
    
    func setupConstraints() {
        pedalImageView.snp.makeConstraints { make in
            make.width.equalTo(20.0)
            make.height.equalTo(26.0)
            make.left.equalTo(contentView).offset(15.0)
            make.centerY.equalTo(contentView)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(pedalImageView.snp.right).offset(15.0)
            make.centerY.equalTo(contentView)
        }
    }
    
    func configure(effectType: EffectType) {
        contentLabel.text = effectType.name
        backgroundColor = UIColor.colorForIndex(effectType.rawValue)
    }
    
    func configure(loopType: LoopType) {
        contentLabel.text = loopType.name
        backgroundColor = UIColor.colorForIndex(loopType.rawValue)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.7 : 1.0
    }
}
