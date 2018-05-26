//
//  File.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/19/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation

enum LoopType: Int {
    case bass
    case drum
    case guitar
    case lead
    case mix
    
    static var count: Int { return LoopType.mix.rawValue + 1}

    var name: String {
        switch self {
        case .bass: return "Bass"
        case .drum: return "Drum"
        case .guitar: return "Guitar"
        case .lead: return "Lead"
        case .mix: return "Mix"
        }
    }
    
    var filename: String {
        switch self {
        case .bass: return "bass"
        case .drum: return "drum"
        case .guitar: return "guitar"
        case .lead: return "lead"
        case .mix: return "mix"
        }
    }
}
