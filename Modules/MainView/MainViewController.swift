//
//  MainViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    let playerViewController = PlayerViewController()
    
    lazy var effectsCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(EffectCollectionViewCell.self, forCellWithReuseIdentifier: EffectCellType.effectCell.identifier)
        collectionView.register(AddEffectCollectionViewCell.self, forCellWithReuseIdentifier: EffectCellType.addEffectCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        self.addChildViewController(playerViewController)
        
        setupViews()
        setupConstraints()
        
        playerViewController.didMove(toParentViewController: self)
    }
    
    func setupViews() {
        view.addSubview(playerViewController.view)
        view.addSubview(effectsCollectionView)
    }
    
    func setupConstraints() {
        playerViewController.view.snp.makeConstraints { make in
            make.top.equalTo(view).offset(44.0)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        effectsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(playerViewController.view.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)            
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfEffectCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModel.cellType(indexPath)
        switch cellType {
        case .effectCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! EffectCollectionViewCell
            cell.configure(effect: viewModel.effectForIndexPath(indexPath))
            return cell
        case .addEffectCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! AddEffectCollectionViewCell
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension MainViewController: PlayerViewContollerDelegate {
    func loadSongButtonWasTapped() {
        
    }
    
    func selectLoopButtonWasTapped() {
        
    }
}
