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
