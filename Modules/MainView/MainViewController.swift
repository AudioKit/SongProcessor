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
        collectionView.showsHorizontalScrollIndicator = false
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
    
    func presentEffectPicker() {
        let effectPickerViewController = EffectPickerViewController()
        effectPickerViewController.delegate = self
        self.addChildViewController(effectPickerViewController)
        view.addSubview(effectPickerViewController.view)
        effectPickerViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(effectsCollectionView)
        }
        effectPickerViewController.view.transform = CGAffineTransform(translationX: 0.0, y: effectsCollectionView.bounds.size.height)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            effectPickerViewController.view.transform = .identity
        }) { _ in 
            effectPickerViewController.didMove(toParentViewController: self)
        }
    }
    
    func dismissChildViewController() {
        guard childViewControllers.count > 0 else { return }
        let childViewController = childViewControllers[childViewControllers.count - 1]
        childViewController.willMove(toParentViewController: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            childViewController.view.transform = CGAffineTransform(translationX: 0.0, y: childViewController.view.bounds.size.height)
        }) { _ in
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParentViewController()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.cellType(indexPath) {
        case .addEffectCell:
            presentEffectPicker()
        default: break
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension MainViewController: PlayerViewContollerDelegate {
    func loadSongButtonWasTapped() {
        
    }
    
    func selectLoopButtonWasTapped() {
        
    }
}

extension MainViewController: EffectPickerDelegate {
    func effectTypeWasSelected(_ effectType: EffectType) {
        let newEffect = Effect(effectType: effectType)
        viewModel.effects.append(newEffect)
        effectsCollectionView.reloadData()
        dismissChildViewController()
    }
    
    func effectPickerWasCancelled() {
        dismissChildViewController()
    }
}
