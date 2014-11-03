//
//  SplashPage.swift
//  NeinTiles
//
//  Created by user on 11/3/14.
//  Copyright (c) 2014 Neva. All rights reserved.
//

import UIKit

class SplashPage: UIViewController {
    
    
    @IBOutlet var splashPageGesture: UISwipeGestureRecognizer!
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: "splashPageSwiped:")
        self.view.addGestureRecognizer(recognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func splashPageSwiped(sender: UISwipeGestureRecognizer) {
        
        performSegueWithIdentifier("beginGame", sender: nil)
    }

   
}
