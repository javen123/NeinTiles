//
//  ScoreCard.swift
//  NeinTiles
//
//  Created by user on 10/24/14.
//  Copyright (c) 2014 Neva. All rights reserved.
//

import Foundation

class ScoreCard:ViewController {
    
    func scoreCardReturn () -> String {
        
        var y:String
        
        if super.currentRoll >= 1 {
            y = "you rock"
        } else {
            y = "try again"
        }
        return y
    }
}


