//
//  Effect.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/20/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

typealias EffectValue = (type: ValueType, value: Double, min: Double, max: Double)

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
    
    var values: [EffectValue] {
        switch self {
        case .delay: return [(.time, 1.0, 0.0, 10.0), (.feedback, 0.5, 0, 1), (.lowPassCutoff, 15000, 0.0, 30000), (.dryWetMix, 0.5, 0.0, 1.0)]
        case .pitchShifter: return [(.shift, AKPitchShifter.defaultShift, AKPitchShifter.shiftRange.lowerBound, AKPitchShifter.shiftRange.upperBound), (.rampTime, 1.0, 0.0, 1.0), (.windowSize, AKPitchShifter.defaultWindowSize, AKPitchShifter.windowSizeRange.lowerBound, AKPitchShifter.windowSizeRange.upperBound), (.crossFade, AKPitchShifter.defaultCrossfade, AKPitchShifter.crossfadeRange.lowerBound, AKPitchShifter.crossfadeRange.upperBound)]
        default: return [EffectValue]()
        }
    }
}

enum ValueType: Int {
    case time = 0
    case feedback
    case lowPassCutoff
    case dryWetMix
    case rampTime
    case shift
    case windowSize
    case crossFade
    
    var name: String {
        switch self {
        case .time: return "Time"
        case .feedback: return "Feedback"
        case .lowPassCutoff: return "Low Pass Cutoff"
        case .dryWetMix: return "Dry Wet Mix"
        case .rampTime: return "Ramp Time"
        case .shift: return "Shift"
        case .windowSize: return "Window Size"
        case .crossFade: return "Cross Fade"
        }
    }
}

class Effect {
    let effectType: EffectType
    let node: AKInput
    var values = [EffectValue]()
    
    init(effectType anEffectType: EffectType) {
        effectType = anEffectType
        node = Effect.nodeForEffectType(effectType)
        values = effectType.values
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
    
    func updateValue(valueType: ValueType, value: Double) {
        values.enumerated().forEach { (index, effectValue) in
            if effectValue.type == valueType {
                values[index].value = value
            }
        }
        
        switch (effectType) {
        case .delay:
            guard let delay = node as? AKDelay else { break }
            switch valueType {
            case .time: delay.time = value
            case .feedback: delay.feedback = value
            case .lowPassCutoff: delay.lowPassCutoff = value
            case .dryWetMix: delay.dryWetMix = value
            default: break
            }
        case .pitchShifter:
            guard let pitchShifter = node as? AKPitchShifter else { break }
            switch valueType {
            case .shift: pitchShifter.shift = value
            case .rampTime: pitchShifter.rampTime = value
            case .crossFade: pitchShifter.crossfade = value
            case .windowSize: pitchShifter.windowSize = value
            default: break
            }
        default: break
        }
    }
}
