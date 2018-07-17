//
//  PlayerViewModel.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation

enum EffectCellType {
    case effectCell
    case addEffectCell
    case pedalCell
    case addPedalCell
    case effectSliderCell
    
    var identifier: String {
        switch self {
        case .effectCell: return "effectCollectionViewCell"
        case .addEffectCell: return "addEffectCollectionViewCell"
        case .pedalCell: return "pedalCollectionViewCell"
        case .addPedalCell: return "addPedalCollectionViewCell"
        case .effectSliderCell: return "effectSliderTableViewCell"
        }
    }
}

class MainViewModel {
    var effects = [Effect]()
    var loopType: LoopType?
    
    var numberOfEffectCells: Int {
        return effects.count + 1
    }
    
    var numberOfPedalCells: Int {
        return effects.count + 1
    }
    
    func effectForIndexPath(_ indexPath: IndexPath) -> Effect {        
        return effects[indexPath.item]
    }
    
    func cellType(_ indexPath: IndexPath, pedal: Bool) -> EffectCellType {
        if pedal { return indexPath.item == effects.count ? EffectCellType.addPedalCell : EffectCellType.pedalCell }
        return indexPath.item == effects.count ? EffectCellType.addEffectCell : EffectCellType.effectCell
    }
    
    func moveEffectAtIndexPath(_ indexPath: IndexPath, to: IndexPath) {
        let effect = effects[indexPath.item]
        effects.remove(at: indexPath.item)
        effects.insert(effect, at: to.item)
    }
    
    func deleteEffectAtIndexPath(_ indexPath: IndexPath) {
        effects.remove(at: indexPath.item)
    }
}
