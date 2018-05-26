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
    func audioWasPaused()
    func audioWasPlayed()
}

class PlayerViewController: UIViewController {
    weak var delegate: PlayerViewContollerDelegate?
    
    let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        imageView.contentMode = .center
        return imageView
    }()
    
    let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    let trackSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(named: "PlayIcon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(playImage, for: .normal)
        button.setImage(playImage, for: [.normal, .highlighted])
        let pauseImage = UIImage(named: "PauseIcon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(pauseImage, for: .selected)
        button.setImage(pauseImage, for: [.selected, .highlighted])
        button.tintColor = UIColor.appRed
        button.addTarget(self, action: #selector(pausePlayButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    let loadSongButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Song", for: .normal)
        button.setTitleColor(UIColor.appRed, for: .normal)
        button.setTitleColor(UIColor.appRed.withAlphaComponent(0.3), for: .highlighted)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(loadSongButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    let selectLoopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Loop", for: .normal)
        button.setTitleColor(UIColor.appRed, for: .normal)
        button.setTitleColor(UIColor.appRed.withAlphaComponent(0.3), for: .highlighted)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.7)
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
        view.addSubview(trackTitleLabel)
        view.addSubview(trackSubtitleLabel)
        view.addSubview(pausePlayButton)
        view.addSubview(loadSongButton)
        view.addSubview(selectLoopButton)
    }
    
    private func setupConstraints() {
        view.snp.makeConstraints { make in
            make.bottom.equalTo(selectLoopButton).offset(30.0)
        }
        trackImageView.snp.makeConstraints { make in
            make.size.equalTo(70.0)
            make.left.equalTo(20.0)
            make.top.equalTo(10.0)
        }
        trackTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(trackImageView.snp.right).offset(15.0)
            make.top.equalTo(trackImageView).offset(10.0)
        }
        pausePlayButton.snp.makeConstraints { make in
            make.size.equalTo(60.0)
            make.right.equalTo(selectLoopButton)
            make.centerY.equalTo(trackImageView)
        }
        trackSubtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(trackImageView.snp.right).offset(15.0)
            make.top.equalTo(trackTitleLabel.snp.bottom).offset(2.0)
        }
        loadSongButton.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.width.equalTo(selectLoopButton)
            make.left.equalTo(view).offset(20.0)
            make.right.equalTo(selectLoopButton.snp.left).offset(-10.0)
            make.top.equalTo(trackImageView.snp.bottom).offset(10.0)
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
    
    @objc private func pausePlayButtonWasTapped() {
        pausePlayButton.isSelected = !pausePlayButton.isSelected
    }
    
    public func loopWasLoaded(loopType: LoopType) {
        trackImageView.image = #imageLiteral(resourceName: "SoundWave")
        trackImageView.backgroundColor = UIColor.colorForIndex(loopType.rawValue)
        trackTitleLabel.text = loopType.name
        trackSubtitleLabel.text = "Audio Loop"
        pausePlayButton.isSelected = true
    }
}
