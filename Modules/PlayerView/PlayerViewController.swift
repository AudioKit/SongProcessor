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
    func loadButtonWasTapped()
    func audioWasPaused()
    func audioWasPlayed()
}

class PlayerViewController: UIViewController {
    weak var delegate: PlayerViewContollerDelegate?
    
    let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return imageView
    }()
    
    let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.alpha = 0.0
        return label
    }()
    
    let trackSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.alpha = 0.0
        return label
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(named: "PlayIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(playImage, for: .normal)
        button.setImage(playImage, for: [.normal, .highlighted])
        let pauseImage = UIImage(named: "PauseIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(pauseImage, for: .selected)
        button.setImage(pauseImage, for: [.selected, .highlighted])
        button.tintColor = UIColor.appRed
        button.addTarget(self, action: #selector(pausePlayButtonWasTapped), for: .touchUpInside)
        button.alpha = 0.0
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tap to play a song or loop", for: .normal)
        button.setTitleColor(UIColor.appRed, for: .normal)
        button.setTitleColor(UIColor.appRed.withAlphaComponent(0.3), for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(loadButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appLightGray.withAlphaComponent(0.2)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(trackImageView)
        view.addSubview(trackTitleLabel)
        view.addSubview(trackSubtitleLabel)
        view.addSubview(loadButton)
        view.addSubview(pausePlayButton)
    }
    
    private func setupConstraints() {
        trackImageView.snp.makeConstraints { make in
            make.size.equalTo(44.0)
            make.left.equalTo(10.0)
            make.top.equalTo(10.0)
        }
        trackTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(trackImageView.snp.right).offset(10.0)
            make.top.equalTo(trackImageView).offset(2.0)
        }
        pausePlayButton.snp.makeConstraints { make in
            make.size.equalTo(44.0)
            make.right.equalTo(view).offset(-10.0)
            make.centerY.equalTo(trackImageView)
        }
        trackSubtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(trackImageView.snp.right).offset(10.0)
            make.top.equalTo(trackTitleLabel.snp.bottom)
        }
        loadButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
        }
    }
    
    @objc private func loadButtonWasTapped() {
        delegate?.loadButtonWasTapped()
    }
    
    @objc private func pausePlayButtonWasTapped() {
        pausePlayButton.isSelected = !pausePlayButton.isSelected
        if pausePlayButton.isSelected {
            delegate?.audioWasPlayed()
        } else {
            delegate?.audioWasPaused()
        }
    }
    
    public func loopWasLoaded(loopType: LoopType) {
        trackImageView.image = #imageLiteral(resourceName: "SoundWave")
        trackImageView.backgroundColor = UIColor.colorForIndex(loopType.rawValue)
        trackTitleLabel.text = loopType.name
        trackSubtitleLabel.text = "Audio Loop"
        pausePlayButton.isSelected = true
        
        UIView.animate(withDuration: 0.3) {
            self.loadButton.setTitle(nil, for: .normal)
            self.trackImageView.alpha = 1.0
            self.trackTitleLabel.alpha = 1.0
            self.trackSubtitleLabel.alpha = 1.0
            self.pausePlayButton.alpha = 1.0
        }
    }
    
    public func songWasPlayed(title: String?, artist: String?, image: UIImage?) {
        trackImageView.image = image
        trackTitleLabel.text = title
        trackSubtitleLabel.text = artist
        pausePlayButton.isSelected = true
        
        UIView.animate(withDuration: 0.3) {
            self.loadButton.setTitle(nil, for: .normal)
            self.trackImageView.alpha = 1.0
            self.trackTitleLabel.alpha = 1.0
            self.trackSubtitleLabel.alpha = 1.0
            self.pausePlayButton.alpha = 1.0
        }
    }
}
