//
//  TestViewController.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/28/16.
//
//

import UIKit
import CoreData
import CoreDataService

class TestViewController: UIViewController {

    @IBOutlet var submitButton: UIButton!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerOneButton: DLRadioButton!
    @IBOutlet var answerTwoButton: DLRadioButton!
    @IBOutlet var answerThreeButton: DLRadioButton!
    
    var testService:TestService?
    
    var questionNum = 10
    var currentQuestionNum:Int = 0
    var pickedAnswer:Int? = nil
    var score = 0
    var result:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerOneButton.otherButtons = [answerTwoButton, answerThreeButton]
        submitButton.hidden = true
        questionLabel.hidden = true
        answerOneButton.hidden = true
        answerTwoButton.hidden = true
        answerThreeButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func startTest(sender: AnyObject) {
        testService = TestService()
        if testService?.getHistoryCount() <= 4{
            //print("You have no word in history")
            let alertController = UIAlertController(title: "Generating Error", message: "You need at least 5 vocabularies in History to Generate a test. You have \(testService!.getHistoryCount()) in History", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            questionNum = (testService?.getQuestionNum())!
            submitButton.setTitle("Confirm", forState: UIControlState.Normal)
            result = "Test status: \n\n"
            
            generateQuestion()
            submitButton.hidden = false
            questionLabel.hidden = false
            answerOneButton.hidden = false
            answerTwoButton.hidden = false
            answerThreeButton.hidden = false
        }
        
    }
    
    @IBAction func ConfirmButton(sender: AnyObject) {
        if pickedAnswer == nil{
            //print("pick a answer")
            let alertController = UIAlertController(title: "Pick an Answer", message: "You did not choose an Answer", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            if ((testService?.checkAnswer(pickedAnswer!)) == true){
                //print("correct")
                score += 1
                result += "Correct! Your answer is \(getAlaphaAnswer(pickedAnswer))\n\n"
            }else{
                //print("wrong")
                result += "Wrong! Your answer is \(getAlaphaAnswer(pickedAnswer)), the correct Answer is \(getAlaphaAnswer(testService?.getCorrectAnswerIndex())) \n\n"
            }
            
            if submitButton.currentTitle == "Finish"{
                result += "Your total score is \(String(score))/\(String(questionNum))"
                questionLabel.text = result
                submitButton.hidden = true
                //questionLabel.hidden = true
                answerOneButton.hidden = true
                answerTwoButton.hidden = true
                answerThreeButton.hidden = true
            }else{
                generateQuestion()
            }
        }
    }
    
    @IBAction func AnswerPicked(sender: DLRadioButton){
        switch sender {
        case answerOneButton:
            //print("answer one clicked")
            pickedAnswer = 0
            break
        case answerTwoButton:
            //print("2")
            pickedAnswer = 1
            break
        case answerThreeButton:
            //print("3")
            pickedAnswer = 2
            break
        default:
            //print("no button clicked")
            pickedAnswer = nil
        }
    }
    
    func generateQuestion(){
        currentQuestionNum += 1
        let question = String(currentQuestionNum) + ": " + (testService?.generateQuestion())!
        let answer1 = "A. " + (testService?.getAnswerOne())!
        let answer2 = "B. " + (testService?.getAnswerTwo())!
        let answer3 = "C. " + (testService?.getAnswerThree())!
        result += question + "\n"
        result += answer1 + answer2
        result += answer3
        
        
        questionLabel.text = question
        answerOneButton.setTitle(answer1, forState: UIControlState.Normal)
        answerTwoButton.setTitle(answer2, forState: UIControlState.Normal)
        answerThreeButton.setTitle(answer3, forState: UIControlState.Normal)
        
        if currentQuestionNum >= questionNum{
            submitButton.setTitle("Finish", forState: UIControlState.Normal)
            currentQuestionNum = 0
        }
        
    }
    
    func getAlaphaAnswer(num:Int?) -> String{
        if num == 0{
            return "A"
        }else if num == 1{
            return "B"
        }else if num == 2{
            return "C"
        }else{
            return ""
        }
    }


}
