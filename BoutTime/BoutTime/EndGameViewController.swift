//
//  EndGameViewController.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/25/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit


class EndGameController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    var score = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = score
        
    }
    
}


