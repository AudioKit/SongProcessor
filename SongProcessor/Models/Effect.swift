//
//  Effect.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/20/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

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
    let node: AKInput
    
    init(effectType anEffectType: EffectType) {
        effectType = anEffectType
        node = Effect.nodeForEffectType(effectType)
    }
    
    class func nodeForEffectType(_ effectType: EffectType) -> AKInput {
        switch effectType {
        case .delay: return AKDelay()
        case .moogLadder: return AKMoogLadder()
        case .reverb: return AKReverb()
        case .pitchShifter: return AKPitchShifter()
        case .bitCrusher: return AKBitCrusher()
        }        
    }
}

