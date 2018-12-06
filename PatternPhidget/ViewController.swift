//
//  ViewController.swift
//  PatternPhidget
//
//  Created by Cristina Lopez on 2018-11-15.
//  Copyright © 2018 Cristina Lopez. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var patternLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let buttonArray = [DigitalInput(), DigitalInput()]
    let ledArray = [DigitalOutput(), DigitalOutput()]
    let led1 = DigitalOutput()
    let led3 = DigitalOutput()
    let button0 = DigitalInput()
    let button2 = DigitalInput()
    
    
    let allPatterns = PatternBank()
    var questionPatternNumber : Int = 0
    var score : Int = 0
    var pickedAnswer1 : Bool = false
    var pickedAnswer2 : Bool = false
    var pickedAnswer3 : Bool = false
    var pickedAnswer4 : Bool = false
    var patternNumberTracker: Int = 0
    
    
    
    //STATE CHANGE FUNCTIONS
    
    func state_change1(sender:DigitalInput, state:Bool){
        do{
            if(state == true && patternNumberTracker == 0){
                pickedAnswer1 = true
                 try led1.setState(true)
                checkAnswer1()
                patternNumberTracker = 1
            }
                
            else if (state == true && patternNumberTracker == 1) {
                pickedAnswer2 = true
                try led1.setState(true)
                checkAnswer2()
                patternNumberTracker = 2
            }
            else if (state == true && patternNumberTracker == 2) {
                pickedAnswer3 = true
                try led1.setState(true)
                checkAnswer3()
                patternNumberTracker = 3
            }
            else if (state == true && patternNumberTracker == 3) {
                pickedAnswer4 = true
                try led1.setState(true)
                checkAnswer4()
                patternNumberTracker = 0
                questionPatternNumber += 1
                nextPattern()
            }
                
            else{
                try led1.setState(false)
                
            }
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    @IBAction func False(_ sender: UIButton) {
    }
    
    func state_change0(sender:DigitalInput, state:Bool){
        do{
            
            if(state == true && patternNumberTracker == 0){
                pickedAnswer1 = false
                try led3.setState(true)
                checkAnswer1()
                patternNumberTracker = 1
            }
                
            else if (state == true && patternNumberTracker == 1) {
                pickedAnswer2 = false
                try led3.setState(true)
                checkAnswer2()
                patternNumberTracker = 2
            }
            else if (state == true && patternNumberTracker == 2) {
                pickedAnswer3 = false
                try led3.setState(true)
                checkAnswer3()
                patternNumberTracker = 3
            }
            else if (state == true && patternNumberTracker == 3) {
                pickedAnswer4 = false
                try led3.setState(true)
                checkAnswer4()
                patternNumberTracker = 0
                questionPatternNumber += 1
                nextPattern()
            }
                
            else{
                print("Button 2 Not Pressed")
                try led3.setState(false)
            }
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    //ATTACH HANDLER
    
    func attach_handler(sender: Phidget){
        do{
            if(try sender.getHubPort() == 0){
                print("LED 1 Attached")
            }
            else{
                print("Button 0 Attached")
            }
            if(try sender.getHubPort() == 2){
                print("LED 3 Attached")
            }
            else{
                print("Button 2 Attached")
            }
            
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let firstPattern = self.allPatterns.list[0]
            self.patternLabel.text = firstPattern.patternSequence
        }
    
        do{
            //enable server discovery
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address objects
            try led1.setDeviceSerialNumber(528251)
            try led1.setHubPort(1)
            try led1.setIsHubPortDevice(true)
            
            try led3.setDeviceSerialNumber(528251)
            try led3.setHubPort(3)
            try led3.setIsHubPortDevice(true)
            
            try button0.setDeviceSerialNumber(528251)
            try button0.setHubPort(2)
            try button0.setIsHubPortDevice(true)
            
            try button2.setDeviceSerialNumber(528251)
            try button2.setHubPort(0)
            try button2.setIsHubPortDevice(true)
            
            //add attach handlers
            let _ = led1.attach.addHandler(attach_handler)
            let _ = led3.attach.addHandler(attach_handler)
            let _ = button0.attach.addHandler(attach_handler)
            let _ = button2.attach.addHandler(attach_handler)
            
            //add state change handler
            let _ = button0.stateChange.addHandler(state_change0)
            let _ = button2.stateChange.addHandler(state_change1)
            
            //open objects
            try button0.open()
            try button2.open()
            try led1.open()
            try led3.open()
            
           
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //other errors here
        }
    }

    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        scoreLabel.text = "\(questionPatternNumber + 1) / 4"
    }
    
    func nextPattern() {
        
        if questionPatternNumber < 4 {
            DispatchQueue.main.async {
                self.patternLabel.text = self.allPatterns.list[self.questionPatternNumber].patternSequence
                self.scoreLabel.text = ("Score: \(self.score)")
            }
        }
            
        else {
            
            DispatchQueue.main.async {
                self.instructionLabel.text = "!"
                self.patternLabel.text = ""
            }
            
            let alert = UIAlertController(title: "Awesome!", message: "You have finished the game! Do you want to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction (title: "Restart", style: .default, handler: { (UIAlertAction) in
                self.startOver()
            })
            
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        
        }
    }
        
    func checkAnswer1() {
        
        let correctAnswer1 = allPatterns.list[questionPatternNumber].answer1
        
        if (pickedAnswer1 == correctAnswer1) {
            print ("1 correct")
        }
        else {
            print("1 wrong")
            
        }
    }
        
    func checkAnswer2() {
        let correctAnswer2 = allPatterns.list[questionPatternNumber].answer2
        if (pickedAnswer2 == correctAnswer2) {
            print ("2 correct")
        }
        else {
            print("2 wrong")
            
        }
    }
            
    func checkAnswer3() {
        let correctAnswer3 = allPatterns.list[questionPatternNumber].answer3
        if (pickedAnswer3 == correctAnswer3) {
            print ("3 correct")
        }
        else {
            print("3 wrong")
            
        }
    }
                
    func checkAnswer4() {

        let correctAnswer1 = allPatterns.list[questionPatternNumber].answer1
        let correctAnswer2 = allPatterns.list[questionPatternNumber].answer2
        let correctAnswer3 = allPatterns.list[questionPatternNumber].answer3
        let correctAnswer4 = allPatterns.list[questionPatternNumber].answer4
        
        if (pickedAnswer4 == correctAnswer4) {
            print ("4 correct")
        }
        else {
            
            print("4 wrong")
            
            }
    

        
        if (pickedAnswer1 == correctAnswer1 && pickedAnswer2 == correctAnswer2 && pickedAnswer3 == correctAnswer3 && pickedAnswer4 == correctAnswer4) {
//        if (correctAnswer1 == pickedAnswer1 && correctAnswer2 == pickedAnswer2 && correctAnswer3 == pickedAnswer3 && correctAnswer4 == pickedAnswer4) {
            DispatchQueue.main.async {
                self.instructionLabel.text = "Correct!"
            }
            score = score + 1
            print("correct")
        }
            
        else {
            print("no score lol")
            DispatchQueue.main.async {
                self.instructionLabel.text = "Wrong!"
            }
        }
        
    }
       
        func startOver () {
            questionPatternNumber = 0
            score = 0
            nextPattern()
        }
    
}


