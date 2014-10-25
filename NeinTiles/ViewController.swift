//
//  ViewController.swift
//  NeinTiles
//
//  Created by user on 10/23/14.
//  Copyright (c) 2014 Neva. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let dieValue = DiceView()
//    let finalTile = ScoreCard()
    var currentRoll = 0
    var sumTiles:Int = 0
//    var reportCard = ScoreCard()
    
    
    // sounds
    var wunderbar:AVAudioPlayer?
    var neinSound:AVAudioPlayer?
    var tileSelectSound:AVAudioPlayer?
    var tileDeSelectSound:AVAudioPlayer?
    var diceRollSound:AVAudioPlayer?
    var submitTileSound:AVAudioPlayer?
    
    // labels
    
    @IBOutlet weak var dieImage1Label: UIImageView!
    @IBOutlet weak var dieImage2Label: UIImageView!
    @IBOutlet weak var submitTileScore: UIButton!
    @IBOutlet weak var rollButtonLabel: UIButton!
    @IBOutlet weak var submitTilesLabel: UIButton!
    @IBOutlet weak var playButtonLabel: UIButton!
    
    // tile button outlet
    
    @IBOutlet var tileButtonsCollection: [UIButton]!
    var tilesArray = [1,2,3,4,5,6,7,8,9]
    var curTiles:[Int] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for items in tileButtonsCollection {
            items.enabled = false
        }
        
        
        
        //default die image view
        
        dieImage1Label.image = UIImage(named: "die6")
        dieImage2Label.image = UIImage(named: "die6")
        
        
        // prepare sounds
        
        if let wunPath = NSBundle.mainBundle().pathForResource("wunderbar", ofType: "m4a") {
            wunderbar = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: wunPath), error: nil)
        }
        wunderbar?.prepareToPlay()
        
        if let tilePath = NSBundle.mainBundle().pathForResource("tilePressedSound", ofType: "m4a") {
            tileSelectSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: tilePath), error: nil)
        }
        tileSelectSound?.prepareToPlay()
        
        if let neinPath = NSBundle.mainBundle().pathForResource("nein", ofType: "m4a") {
            neinSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: neinPath), error: nil)
        }
        
        neinSound?.prepareToPlay()
        
        if let tileDPath = NSBundle.mainBundle().pathForResource("tileDepressedSound", ofType: "m4a") { tileDeSelectSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: tileDPath), error: nil)
        }
        tileDeSelectSound?.prepareToPlay()
        
        if let rollPath = NSBundle.mainBundle().pathForResource("diceRoll", ofType: "m4a") {
            diceRollSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: rollPath), error: nil)
        }
        diceRollSound?.prepareToPlay()
        
        if let submitPath = NSBundle.mainBundle().pathForResource("submitTileSound", ofType: "m4a") {
            submitTileSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: submitPath), error: nil)
        }
        submitTileSound?.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playButtonPressed(sender: AnyObject) {
        
        rollButtonLabel.hidden = false
        playButtonLabel.hidden = true
        for items in tileButtonsCollection {
            
            items.selected = false
        }
        
    }
    @IBAction func rollButtonPressed (sender: UIButton) {
        
        currentRoll = 0
        
        rotateDie()
        diceRollSound?.play()
        updateView()
        let finalTile = ScoreCard()
        var aFinalTile = finalTile.scoreCardReturn()
        
        
        // dice label update count
        
        let firstDieValue = dieValue.randomDieValue()
        let secondDieValue = dieValue.randomDieValue()
        
        currentRoll = firstDieValue.0 + secondDieValue.0
        dieImage1Label.image = firstDieValue.1
        dieImage2Label.image = secondDieValue.1
        
        var curRound = roundOver(tilesArray, value: currentRoll)
        
        rollButtonLabel.hidden = true
        
        if curRound == false {
            roundOverAlert(header: "Nein", message: "Final Score is \(tilesArray.reduce(0, combine: +)), your last roll was \(aFinalTile)")
        }
        println(curRound)
    }
    
    @IBAction func tileButtonsPressed (sender: UIButton) {
        
        var aTag = sender.tag
        
        //toggle button state
        
        sender.selected = !sender.selected
        
        // Update tile counts
        
        if sender.selected == true {
            sender.selected = true
            tileSelectSound?.play()
            tilesArray = tilesArray.filter({$0 != aTag})
            curTiles.append(aTag)
        }
        else if sender.selected == false {
            sender.selected = false
            tileDeSelectSound?.play()
            curTiles = curTiles.filter({$0 != aTag})
            tilesArray.append(aTag)
        }
        matchTileDice()
     }
    
    
    @IBAction func submitTileCountButtonPressed(sender: AnyObject) {
        
        updateView()
        submitTileSound?.play()
        submitTileScore.hidden = true
        curTiles.removeAll(keepCapacity: true)
        rollButtonLabel.hidden = false
        println(tilesArray)
        if tilesArray.count == 0 {
            gameWon(header: "Wunderbar", message: "You've blitzed the game. You're pretty awesome and I hope you won some money because of this")
        }
    }

    
    // Helpers
    
    func showAlert (header:String = "Nein", message:String) {
        neinSound?.play()
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func gameWon (header:String = "Wunderbar", message:String) {
        wunderbar?.play()
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: {self.reset()})
    }
    
    func roundOverAlert (header:String = "Nein", message: String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: {self.reset()})
        
    }

    func roundOver(var array: [Int], value: Int) -> Bool {
        
        if value == 0 {
            // We have reached the exact sum
            return true
        } else if array.count == 0 {
            // No elements left to try
            return false
        }
        // Split into first element and remaining array:
        let first = array.removeAtIndex(0)
        // Try to build the sum without or with the first element:
        return roundOver(array, value: value) || (value >= first && roundOver(array, value: value - first))
        
    }
    
    func rotateDie () {
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: .CurveLinear,
            animations: {self.dieImage1Label.transform = CGAffineTransformRotate(self.dieImage1Label.transform, 3.1415926)},
            completion: nil)
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: .CurveLinear,
            animations: {self.dieImage2Label.transform = CGAffineTransformRotate(self.dieImage2Label.transform, 3.1415926)},
            completion: nil)
        
        
    }
    
    func matchTileDice () {
        sumTiles = curTiles.reduce(0, combine: +)
        if sumTiles == currentRoll {
            submitTileScore.hidden = false
        } else if sumTiles > currentRoll {
            showAlert(header: "Nein", message: "Must equal dice count")
        } else {
            submitTileScore.hidden = true
        }
        println(sumTiles)
    }
    
    
    func updateView () {
        
        for items in tileButtonsCollection {
            items.enabled = true
            for items in tileButtonsCollection {
                if items.selected == true {
                    items.enabled = false
                }
            }
        }
    }
    
    func reset () {
        
        dieImage1Label.image = UIImage(named: "die6")
        dieImage2Label.image = UIImage(named: "die6")
        
        
        for items in tileButtonsCollection {
            items.enabled = false
            items.selected = false
        
        playButtonLabel.hidden = false
        curTiles.removeAll(keepCapacity: true)
        tilesArray = [1,2,3,4,5,6,7,8,9]
        
    }

}
}