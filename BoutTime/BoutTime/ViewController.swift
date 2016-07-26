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
    var roundNumber = 1
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
    @IBOutlet weak var roundsLabel: UILabel!
    
    
    //Buttons
    @IBOutlet weak var downButton1: UIButton!
    @IBOutlet weak var upButton1: UIButton!
    @IBOutlet weak var downButton2: UIButton!
    @IBOutlet weak var upButton2: UIButton!
    @IBOutlet weak var downButton3: UIButton!
    @IBOutlet weak var upButton3: UIButton!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    
    var eventLabels: [UILabel] = []
    var directionButtons: [UIButton] = []
    
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
        displayRound(eventsList)
        roundsLabel.text = "Round: \(roundNumber)"
        directionButtons = [upButton1, upButton2, upButton3, downButton1, downButton2, downButton3]
        
        //Round corners of Labels
        let labelsArray = [event1Label, event2Label, event3Label, event4Label]
        for label in labelsArray {
            let bounds = label.bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.TopLeft, .BottomLeft], cornerRadii: CGSize(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.CGPath
            label.layer.mask = maskLayer
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRound(array: [Event]) {
        resetTimerAndButtons()
        beginTimer()
        newQuizEvents = array.shuffle
        
        for i in 0...3 {
            currentRoundEvents.append(newQuizEvents[i])
        }
        
        updateLabels()
    }
    
    func checkAnswer(userAnswer: [Event]) {
        roundsCompleted += 1
        timer.invalidate()
        
        let correctAnswer = currentRoundEvents.sort{$0.year < $1.year}
        
        if (userAnswer[0].event == correctAnswer[0].event && userAnswer[1].event == correctAnswer[1].event && userAnswer[2].event == correctAnswer[2].event && userAnswer[3].event == correctAnswer[3].event) {
            
            numberOfCorrectRounds += 1
            passButton.hidden = false
            timerLabel.hidden = true
            enableDirectionButtons(interactionEnabled: false)
            labelsToInfoButtons(interactionEnabled: true)
            instructions.text = "Tap an Event to find out more"
        
        } else {
           
            failButton.hidden = false
            timerLabel.hidden = true
            enableDirectionButtons(interactionEnabled: false)
            labelsToInfoButtons(interactionEnabled: true)
            instructions.text = "Tap an Event to find out more"

        }
        
    }
    
    func newRound() {
        if roundNumber < 6 {
            roundNumber += 1
            roundsLabel.text = "Round: \(roundNumber)"
            currentRoundEvents.removeAll()
            displayRound(eventsList)
            failButton.hidden = true
            passButton.hidden = true
            timerLabel.hidden = false
            enableDirectionButtons(interactionEnabled: true)
            instructions.text = "Shake to complete"
            labelsToInfoButtons(interactionEnabled: false)
            
        } else {
            endGame()
        }
    }
    
    @IBAction func newRoundPressed(sender: UIButton) {
        switch sender.tag {
            case 1:
                newRound()
            case 2:
                newRound()
        default:
                break;
        }
    }
    
    @IBAction func moveUpOrDown(sender: UIButton) {
        switch sender.tag {
        case 1:
            swap(&currentRoundEvents[0], &currentRoundEvents[1])
        case 2:
            swap(&currentRoundEvents[1], &currentRoundEvents[0])
        case 3:
            swap(&currentRoundEvents[1], &currentRoundEvents[2])
        case 4:
            swap(&currentRoundEvents[2], &currentRoundEvents[1])
        case 5:
            swap(&currentRoundEvents[2], &currentRoundEvents[3])
        case 6:
            swap(&currentRoundEvents[3], &currentRoundEvents[2])
        default:
            break;
        }
        updateLabels()
    }
    
    func endGame() {
        roundNumber == 1
        roundsLabel.text = "Round: \(roundNumber)"
        currentRoundEvents.removeAll()
        
        let endGameViewController = self.storyboard?.instantiateViewControllerWithIdentifier("endGameVC") as! EndGameController
        endGameViewController.score = "\(numberOfCorrectRounds)/6"
        self.presentViewController(endGameViewController, animated: true, completion: nil)
    }
    
    func updateLabels() {
        event1Label.text = currentRoundEvents[0].event
        event2Label.text = currentRoundEvents[1].event
        event3Label.text = currentRoundEvents[2].event
        event4Label.text = currentRoundEvents[3].event
    }
    
    //Shake Feature
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            checkAnswer(currentRoundEvents)
        }
    }
    
    //TapForMoreInfo
    
    func labelsToInfoButtons(interactionEnabled bool :Bool) {
        eventLabels = [event1Label, event2Label, event3Label, event4Label]
        for label in eventLabels {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapForMoreInfo))
            label.addGestureRecognizer(tapGesture)
        }
        for label in eventLabels {
            if bool == true {
                label.userInteractionEnabled = true
            } else {
                label.userInteractionEnabled = false 
            }
        }
    }
    
    func tapForMoreInfo(gesture: UITapGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.Ended) {
            print("event tapped")
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
            checkAnswer(currentRoundEvents)
        }
    }
    
    func resetTimerAndButtons() {
        time = 60
        timerLabel.text = "0:\(time)"
        timerRunning = false
        timerLabel.textColor = UIColor.whiteColor()
    }
    
    //Button Enabling
    
    func enableDirectionButtons(interactionEnabled bool: Bool) {
        directionButtons = [upButton1, upButton2, upButton3, downButton1, downButton2, downButton3]
        for button in directionButtons {
            if bool == true {
                button.userInteractionEnabled = true
            } else {
                button.userInteractionEnabled = false
            }
        }
    }


}

