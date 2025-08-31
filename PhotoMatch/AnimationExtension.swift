//
//  AnimationExtension.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI

// EXTEND ANIMATION FOR CODE EFFICIENCY

extension Animation {
    
    static func spin1(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatCount(1)
        
    }
}

