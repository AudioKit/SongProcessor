//
//  PlayerViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayerViewContollerDelegate: class {
    func loadSongButtonWasTapped()
    func selectLoopButtonWasTapped()
}

class PlayerViewController: UIViewController {
    weak var delegate: PlayerViewContollerDelegate?
    
    let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.backgroundColor = UIColor.rgb(r: 247, g: 248, b: 252)
        return imageView
    }()
    
    let loadSongButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Song", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89, a: 0.3), for: .highlighted)
        button.backgroundColor = UIColor.rgb(r: 247, g: 248, b: 252)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(loadSongButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    let selectLoopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Loop", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 249, g: 49, b: 89, a: 0.3), for: .highlighted)
        button.backgroundColor = UIColor.rgb(r: 247, g: 248, b: 252)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(selectLoopButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(trackImageView)
        view.addSubview(loadSongButton)
        view.addSubview(selectLoopButton)
    }
    
    private func setupConstraints() {
        view.snp.makeConstraints { make in
            make.bottom.equalTo(selectLoopButton).offset(30.0)
        }
        trackImageView.snp.makeConstraints { make in
            make.size.equalTo(140.0)
            make.left.equalTo(20.0)
            make.top.equalTo(20.0)
        }
        loadSongButton.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.width.equalTo(selectLoopButton)
            make.left.equalTo(view).offset(20.0)
            make.right.equalTo(selectLoopButton.snp.left).offset(-20.0)
            make.top.equalTo(trackImageView.snp.bottom).offset(20.0)
        }
        selectLoopButton.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.right.equalTo(view).offset(-20.0)
            make.left.equalTo(loadSongButton.snp.right).offset(20.0)
            make.centerY.equalTo(loadSongButton)
        }
    }
    
    @objc private func loadSongButtonWasTapped() {
        delegate?.loadSongButtonWasTapped()
    }
    
    @objc private func selectLoopButtonWasTapped() {
        delegate?.selectLoopButtonWasTapped()
    }
}
