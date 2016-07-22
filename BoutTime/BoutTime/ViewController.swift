//
//  ViewController.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Game Variables
    var roundsCompleted = 0
    var numberOfCorrectRounds = 0
    var numberOfRoundsCompleted = 0
    var totalNumberOfRounds = 6
    var indexOfEvent = 0
    var eventsList: [Event] = []
    var currentRoundEvents: [Event] = []
    var nextRoundEvents: [Event] = []
    
    //Labels
    @IBOutlet weak var event1Label: UILabel!
    @IBOutlet weak var event2Label: UILabel!
    @IBOutlet weak var event3Label: UILabel!
    @IBOutlet weak var event4Label: UILabel!
    @IBOutlet weak var instructions: UILabel!
    
    
    //Buttons
    @IBOutlet weak var downButton1: UIButton!
    @IBOutlet weak var upButton1: UIButton!
    @IBOutlet weak var downButton2: UIButton!
    @IBOutlet weak var upButton2: UIButton!
    @IBOutlet weak var downButton3: UIButton!
    @IBOutlet weak var upButton3: UIButton!
    
    //Timer
    @IBOutlet weak var timerLabel: UILabel!
    var timer = NSTimer()
    var time = 60
    var timerRunning = false
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("PixarEvents", ofType: "plist")
            self.eventsList = EventsUnarchiver.eventsFromArray(array)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        displayRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRound() {
        resetTimerAndButtons()
        beginTimer()
    }
    
    //Timer
    
    func beginTimer() {
        if timerRunning == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.displayCountDown), userInfo: nil, repeats: true)
            
            timerRunning = true
        }
    }
    
    func displayCountDown() {
        time -= 1
        timerLabel.text = "0:\(time)"
        
        if time <= 5 {
            timerLabel.textColor = UIColor.redColor()
        }
        
        if time == 0 {
            timer.invalidate()
            instructions.text = "Time's up!"
        }
    }
    
    func resetTimerAndButtons() {
        time = 60
        timerLabel.text = "0:\(time)"
        timerRunning = false
        timerLabel.textColor = UIColor.whiteColor()
    }


}

