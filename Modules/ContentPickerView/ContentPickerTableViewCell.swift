//
//  EffectPickerTableViewCell.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class ContentPickerTableViewCell: UITableViewCell {
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
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(mainView)
        mainView.addSubview(pedalImageView)
        mainView.addSubview(contentLabel)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5.0)
            make.right.equalTo(contentView).offset(-5.0)
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(5.0)
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
    
    func configure(effectType: EffectType) {
        contentLabel.text = effectType.name
        mainView.backgroundColor = UIColor.colorForIndex(effectType.rawValue)
        pedalImageView.image = #imageLiteral(resourceName: "EffectPedal")
    }
    
    func configure(loopType: LoopType) {
        contentLabel.text = loopType.name
        mainView.backgroundColor = UIColor.colorForIndex(loopType.rawValue)
        pedalImageView.image = #imageLiteral(resourceName: "SoundWave")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.7 : 1.0
    }
}
