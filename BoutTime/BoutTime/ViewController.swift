//
//  ViewController.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

//Extension to randomize events for each round
extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex {
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
    func groupOf(n:Int)-> [[Element]] {
        var result:[[Element]]=[]
        for i in 0...(count/n)-1 {
            var tempArray:[Element] = []
            for index in 0...n-1 {
                tempArray.append(self[index+(i*n)])
            }
            result.append(tempArray)
        }
        
        return result
    }
}

class ViewController: UIViewController {
    
    //Game Variables
    var roundsCompleted = 0
    var numberOfCorrectRounds = 0
    var numberOfRoundsCompleted = 0
    var totalNumberOfRounds = 6
    var indexOfEvent = 0
    var eventsList: [Event] = []
    var newQuizEvents: [Event] = []
    var currentRoundEvents: [Event] = []
    
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
        newQuizEvents = eventsList.shuffle
        displayRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRound() {
        resetTimerAndButtons()
        beginTimer()
        
        for i in 0...3 {
            currentRoundEvents.append(newQuizEvents[i])
        }
        
        event1Label.text = currentRoundEvents[0].event
        event2Label.text = currentRoundEvents[1].event
        event3Label.text = currentRoundEvents[2].event
        event4Label.text = currentRoundEvents[3].event
    }
    
    func newRound() {
        newQuizEvents.shuffle
    }
    
    @IBAction func moveUpOrDown(sender: UIButton) {
        switch sender.tag {
        case 1:
            swap(&event1Label.text, &event2Label.text)
        case 2:
            swap(&event2Label.text, &event1Label.text)
        case 3:
            swap(&event2Label.text, &event3Label.text)
        case 4:
            swap(&event3Label.text, &event2Label.text)
        case 5:
            swap(&event3Label.text, &event4Label.text)
        case 6:
            swap(&event4Label.text, &event3Label.text)
        default:
            break;
        }
    
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

