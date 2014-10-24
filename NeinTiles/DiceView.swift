//
//  DiceView.swift
//  NeinTiles
//
//  Created by user on 10/24/14.
//  Copyright (c) 2014 Neva. All rights reserved.
//

import Foundation
import UIKit

class DiceView {
    
    func randomDieValue () -> (Int, UIImage?) {
    
        
       var diceValuesArray = [(1, UIImage(named: "die1")), (2, UIImage(named: "die2")), (3, UIImage(named: "die3")), (4, UIImage(named: "die4")), (5, UIImage(named: "die5")), (6, UIImage(named: "die6"))]
        
        let x = Int(arc4random_uniform(UInt32(diceValuesArray.count)))
        let y = diceValuesArray[x]
        
        return y
    }

    
    
}
