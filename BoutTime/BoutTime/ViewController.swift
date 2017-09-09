//
//  ViewController.swift
//  BoutTime
//
//  Created by Joanna Lingenfelter on 7/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    //Game Variables
    var roundsCompleted = 0
    var numberOfCorrectRounds = 0
    var roundNumber = 1
    var totalNumberOfRounds = 6
    var indexOfEvent = 0
    let eventQuiz = EventQuiz()
    
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
    var timer: Timer?
    var time = 60
    
    var eventURL = String()
    
    //Sound Effects
    let soundCoordinator = SoundCoordinator()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.displayCountDown), userInfo: nil, repeats: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayRound(eventQuiz.quizArray)
        roundsLabel.text = "Round: \(roundNumber)"
        directionButtons = [upButton1, upButton2, upButton3, downButton1, downButton2, downButton3]
        
        //Round corners of Labels
        eventLabels = [event1Label, event2Label, event3Label, event4Label]
        for label in eventLabels {
            let bounds = label.bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            label.layer.mask = maskLayer
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func displayRound(_ array: [Event]) {
        resetTimerAndButtons()
        updateLabels()
    }
    
    func checkAnswer(_ userAnswer: [Event]) {
        roundsCompleted += 1
        
        let correctAnswer = eventQuiz.quizArray.sorted{$0.year < $1.year}
        
        if (userAnswer[0].event == correctAnswer[0].event && userAnswer[1].event == correctAnswer[1].event && userAnswer[2].event == correctAnswer[2].event && userAnswer[3].event == correctAnswer[3].event) {
            
            numberOfCorrectRounds += 1
            passButton.isHidden = false
            timerLabel.isHidden = true
            enableDirectionButtons(interactionEnabled: false)
            instructions.text = "Tap an Event to find out more"
            enableLabelInteraction(interactionEnabled: true)
            soundCoordinator.playCorrectSound()
        
        } else {
           
            failButton.isHidden = false
            timerLabel.isHidden = true
            enableDirectionButtons(interactionEnabled: false)
            instructions.text = "Tap an Event to find out more"
            enableLabelInteraction(interactionEnabled: true)
            soundCoordinator.playIncorrectSound()

        }
        
    }
    
    func newRound() {
        if roundNumber < 6 {
            roundNumber += 1
            roundsLabel.text = "Round: \(roundNumber)"
            eventQuiz.newQuiz()
            displayRound(eventQuiz.quizArray)
            failButton.isHidden = true
            passButton.isHidden = true
            timerLabel.isHidden = false
            enableDirectionButtons(interactionEnabled: true)
            instructions.text = "Shake to complete"
            enableLabelInteraction(interactionEnabled: false)
            
        } else {
            endGame()
        }
    }
    
    @IBAction func newRoundPressed(_ sender: UIButton) {
        switch sender.tag {
            case 1:
                newRound()
            case 2:
                newRound()
        default:
                break;
        }
    }
    
    @IBAction func moveUpOrDown(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            swap(&eventQuiz.quizArray[0], &eventQuiz.quizArray[1])
        case 2:
            swap(&eventQuiz.quizArray[1], &eventQuiz.quizArray[0])
        case 3:
            swap(&eventQuiz.quizArray[1], &eventQuiz.quizArray[2])
        case 4:
            swap(&eventQuiz.quizArray[2], &eventQuiz.quizArray[1])
        case 5:
            swap(&eventQuiz.quizArray[2], &eventQuiz.quizArray[3])
        case 6:
            swap(&eventQuiz.quizArray[3], &eventQuiz.quizArray[2])
        default:
            break;
        }
        updateLabels()
    }
    
    func endGame() {
        roundNumber = 1
        roundsLabel.text = "Round: \(roundNumber)"
        
        let endGameViewController = self.storyboard?.instantiateViewController(withIdentifier: "endGameVC") as! EndGameController
        endGameViewController.score = "\(numberOfCorrectRounds)/6"
        self.present(endGameViewController, animated: true, completion: nil)
    }
    
    func updateLabels() {
        event1Label.text = eventQuiz.quizArray[0].event
        event2Label.text = eventQuiz.quizArray[1].event
        event3Label.text = eventQuiz.quizArray[2].event
        event4Label.text = eventQuiz.quizArray[3].event
    }
    
    //Shake Feature
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer(eventQuiz.quizArray)
        }
    }
    
    //TapForMoreInfo
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        
        if touch.view == event1Label {
            eventURL = eventQuiz.quizArray[0].url
            webViewWithURL(eventURL)
            
        } else if touch.view == event2Label {
            eventURL = eventQuiz.quizArray[1].url
            webViewWithURL(eventURL)
            
        } else if touch.view == event3Label {
            eventURL = eventQuiz.quizArray[2].url
            webViewWithURL(eventURL)
            
        } else if touch.view == event4Label {
            eventURL = eventQuiz.quizArray[3].url
            webViewWithURL(eventURL)
            
        }
        
    }
    
    func webViewWithURL(_ URL: String) {
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! WebViewController
        webViewController.url = URL
        self.present(webViewController, animated: true, completion: nil)
        
    }
    
    //Timer
    
    func displayCountDown() {
        time -= 1
        timerLabel.text = "0:\(time)"
        
        if time < 10 && time > 0 {
            timerLabel.text = "0:0\(time)"
        }
        
        if time <= 5 {
            timerLabel.textColor = UIColor.red
        }
        
        if time == 0 {
            instructions.text = "Time's up!"
            checkAnswer(eventQuiz.quizArray)
        }
    }
    
    func resetTimerAndButtons() {
        time = 60
        timerLabel.text = "0:\(time)"
        timerLabel.textColor = UIColor.white
    }
    
    //Button Enabling
    
    func enableDirectionButtons(interactionEnabled bool: Bool) {
        directionButtons = [upButton1, upButton2, upButton3, downButton1, downButton2, downButton3]
        for button in directionButtons {
            if bool == true {
                button.isUserInteractionEnabled = true
            } else {
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func enableLabelInteraction(interactionEnabled bool: Bool) {
        for label in eventLabels {
            if bool == true {
                label.isUserInteractionEnabled = true
            } else {
                label.isUserInteractionEnabled = false
            }
        }
    }
}

