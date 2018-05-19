//
//  PlayerViewModel.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/9/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation

enum EffectType: Int {
    case delay = 0
    case moogLadder
    case reverb
    case pitchShifter
    case bitCrusher
    
    static var count: Int { return EffectType.bitCrusher.rawValue + 1}
    
    var name: String {
        switch self {
        case .delay: return "Delay"
        case .moogLadder: return "Moog Ladder"
        case .reverb: return "Reverb"
        case .pitchShifter: return "Pitch Shifter"
        case .bitCrusher: return "Bit Crusher"
        }
    }
}

class Effect {
    let effectType: EffectType
    
    init(effectType anEffectType: EffectType) {
        effectType = anEffectType
    }
}

enum EffectCellType {
    case effectCell
    case addEffectCell
    
    var identifier: String {
        switch self {
        case .effectCell: return "effectCollectionViewCell"
        case .addEffectCell: return "addEffectCollectionViewCell"
        }
    }
}

class MainViewModel {
    var effects = [Effect]()
    var loopType: LoopType?
    
    var numberOfEffectCells: Int {
        return effects.count + 1
    }
    
    func effectForIndexPath(_ indexPath: IndexPath) -> Effect {
        return effects[indexPath.item]
    }
    
    func cellType(_ indexPath: IndexPath) -> EffectCellType {
        return indexPath.item == effects.count ? EffectCellType.addEffectCell : EffectCellType.effectCell
    }
}
