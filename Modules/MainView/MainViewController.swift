//
//  MainViewController.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit
import MediaPlayer

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
        collectionView.backgroundColor = UIColor.appDarkGray
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    lazy var pedalsCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(PedalCollectionViewCell.self, forCellWithReuseIdentifier: EffectCellType.pedalCell.identifier)
        collectionView.register(AddPedalCollectionViewCell.self, forCellWithReuseIdentifier: EffectCellType.addPedalCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.appDarkGray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.clipsToBounds = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appDarkGray
        self.navigationController?.navigationBar.barTintColor = UIColor.appDarkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.appRed, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]
        self.title = "Song Processor"
        
        self.addChildViewController(playerViewController)
        
        setupViews()
        setupConstraints()
        
        playerViewController.didMove(toParentViewController: self)
        playerViewController.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        pedalsCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func setupViews() {
        view.addSubview(effectsCollectionView)
        view.addSubview(pedalsCollectionView)
        view.addSubview(playerViewController.view)
    }
    
    func setupConstraints() {
        effectsCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(view)
            }
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(pedalsCollectionView.snp.top)
        }
        pedalsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(playerViewController.view.snp.top).offset(-10.0)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(54.0)
        }
        playerViewController.view.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-64.0)
            } else {
                make.top.equalTo(view.snp.bottom).offset(-64.0)
            }
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let collectionView = pedalsCollectionView
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func presentContentPicker(contentPickerType: ContentPickerType) {
        let contentPickerViewController = ContentPickerViewController(contentPickerType: contentPickerType)
        contentPickerViewController.delegate = self
        self.addChildViewController(contentPickerViewController)
        view.addSubview(contentPickerViewController.view)
        contentPickerViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        contentPickerViewController.view.transform = CGAffineTransform(translationX: 0.0, y: effectsCollectionView.bounds.size.height)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            contentPickerViewController.view.transform = .identity
        }) { _ in
            contentPickerViewController.didMove(toParentViewController: self)
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
    
    func loadSongButtonWasTapped() {
        let mediaPickerController = MPMediaPickerController(mediaTypes: MPMediaType.anyAudio)
        mediaPickerController.delegate = self
        mediaPickerController.showsCloudItems = false
        mediaPickerController.showsItemsWithProtectedAssets = false
        present(mediaPickerController, animated: true)
    }
    
    func loadLoopButtonWasTapped() {
        presentContentPicker(contentPickerType: .loop)
    }
    
    @objc func trashButtonWasTapped(button: UIButton) {
        let indexPath = IndexPath(item: button.tag, section: 0)
        viewModel.deleteEffectAtIndexPath(indexPath)
        effectsCollectionView.deleteItems(at: [indexPath])
        pedalsCollectionView.deleteItems(at: [indexPath])
        SongProcessor.sharedInstance.updateEffectsChain(effects: viewModel.effects)
    }
    
    @objc func resetButtonWasTapped(button: UIButton) {
        let indexPath = IndexPath(item: button.tag, section: 0)
        let effect = viewModel.effectForIndexPath(indexPath)
        effect.values = effect.effectType.values
        effectsCollectionView.reloadData()
        for effectValue in effect.values {
            effect.updateValue(valueType: effectValue.type, value: effectValue.value)
        }
    }
    
    @objc func sliderValueWasChanged(slider: UISlider) {
        guard let currentIndexPath = effectsCollectionView.indexPathForItem(at: view.convert(view.center, to: effectsCollectionView)) else { return }
        let effect = viewModel.effectForIndexPath(currentIndexPath)
        guard slider.tag < effect.values.count else { return }
        let effectValue = effect.values[slider.tag].type
        effect.updateValue(valueType: effectValue, value: Double(slider.value))
        print(slider.value)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == effectsCollectionView {
            return viewModel.numberOfEffectCells
        } else {
            return viewModel.numberOfPedalCells
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModel.cellType(indexPath, pedal: collectionView == pedalsCollectionView)
        switch cellType {
        case .effectCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! EffectCollectionViewCell
            cell.tableView.tag = indexPath.item
            cell.tableView.dataSource = self
            cell.tableView.delegate = self
            cell.configure(effect: viewModel.effectForIndexPath(indexPath))
            cell.tableView.reloadData()
            cell.trashButton.removeTarget(self, action: nil, for: UIControlEvents.allEvents)
            cell.trashButton.tag = indexPath.item
            cell.trashButton.addTarget(self, action: #selector(trashButtonWasTapped(button:)), for: .touchUpInside)
            cell.resetButton.removeTarget(self, action: nil, for: UIControlEvents.allEvents)
            cell.resetButton.tag = indexPath.item
            cell.resetButton.addTarget(self, action: #selector(resetButtonWasTapped(button:)), for: .touchUpInside)
            return cell
        case .addEffectCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! AddEffectCollectionViewCell
            return cell
        case .pedalCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! PedalCollectionViewCell
            cell.configure(effect: viewModel.effectForIndexPath(indexPath))
            return cell
        case .addPedalCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! AddPedalCollectionViewCell
            cell.configureAsAddButton()
            return cell
        default: return UICollectionViewCell()
        }
    }
}
    
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.cellType(indexPath, pedal: collectionView == pedalsCollectionView) {
        case .pedalCell:
            effectsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pedalsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        case .addEffectCell, .addPedalCell:
            presentContentPicker(contentPickerType: .effect)
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return collectionView == pedalsCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveEffectAtIndexPath(sourceIndexPath, to: destinationIndexPath)
        effectsCollectionView.reloadData()
        SongProcessor.sharedInstance.updateEffectsChain(effects: viewModel.effects)
    }
        
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? EffectCollectionViewCell {
            cell.audioPlotView.node = nil
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == effectsCollectionView {
            return collectionView.bounds.size
        } else {
            return CGSize(width: 160.0, height: collectionView.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == pedalsCollectionView {
            return UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 7.0)
        } else {
            return UIEdgeInsets.zero
        }
    }
}

extension MainViewController: PlayerViewContollerDelegate {
    func audioWasPaused() {
        SongProcessor.sharedInstance.player.pause()
    }
    
    func audioWasPlayed() {
        SongProcessor.sharedInstance.player.resume()
    }
    
    func loadButtonWasTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let loadSongAction = UIAlertAction(title: "Play a song from iTunes Library", style: UIAlertActionStyle.default) { action in
            self.loadSongButtonWasTapped()
        }
        alertController.addAction(loadSongAction)
        
        let loadLoopAction = UIAlertAction(title: "Play a loop", style: UIAlertActionStyle.default) { action in
            self.loadLoopButtonWasTapped()
        }
        alertController.addAction(loadLoopAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertController, animated: true)
    }
    
}

extension MainViewController: ContentPickerDelegate {
    func loopTypeWasSelected(_ loopType: LoopType) {
        viewModel.loopType = loopType
        playerViewController.loopWasLoaded(loopType: loopType)
        SongProcessor.sharedInstance.playNew(loop: loopType.filename)
        SongProcessor.sharedInstance.currentLoop = loopType
        dismissChildViewController()
    }
    
    func contentPickerWasCancelled() {
        dismissChildViewController()
    }
    
    func effectTypeWasSelected(_ effectType: EffectType) {
        let newEffect = Effect(effectType: effectType)
        viewModel.effects.append(newEffect)
        effectsCollectionView.reloadData()
        pedalsCollectionView.reloadData()
        let lastIndexPath = IndexPath(item: viewModel.numberOfPedalCells - 1, section: 0)
        pedalsCollectionView.scrollToItem(at: lastIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
        dismissChildViewController()
        SongProcessor.sharedInstance.updateEffectsChain(effects: viewModel.effects)
    }
}

extension MainViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true, completion: nil)
        guard mediaItemCollection.items.count > 0 else { return }
        let mediaItem = mediaItemCollection.items[0]
        guard let url = mediaItem.assetURL else { return }
        
        SongProcessor.sharedInstance.playUrl(url: url)
        playerViewController.songWasPlayed(title: mediaItem.title, artist: mediaItem.artist, image: mediaItem.artwork?.image(at: CGSize(width: 44.0, height: 44.0)))
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let effect = viewModel.effectForIndexPath(IndexPath(item: tableView.tag, section: 0))
        return effect.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EffectCellType.effectSliderCell.identifier, for: indexPath) as! EffectSliderTableViewCell
        let effect = viewModel.effectForIndexPath(IndexPath(item: tableView.tag, section: 0))
        cell.configure(effectValue: effect.values[indexPath.row])
        cell.slider.removeTarget(self, action: nil, for: UIControlEvents.allEvents)
        cell.slider.tag = indexPath.row
        cell.slider.addTarget(self, action: #selector(sliderValueWasChanged(slider:)), for: UIControlEvents.valueChanged)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
