//
//  TestService.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/30/16.
//
//

import Foundation
import CoreData
import CoreDataService

extension Int{
    public static func random(_ upper:Int) -> Int{
        //generate random int between 0 and upper(include)
        return Int(arc4random_uniform(UInt32(upper)))
    }
}

class TestService{
    
    //temperoy number, fix after setting is done
    var questionNumber = 10
    
    var randomIndex:Int?
    
    let coreDataService:CoreDataService
    let context:NSManagedObjectContext
    let historyFetchRequest:NSFetchRequest<AnyObject>
    var historyFetchedResults:[VocaHistory]? = nil
    
    var questionArray:[Vocabulary] = []
    var answerArray:[String] = []
    
    var correctAnswerInt:Int?
    var correctAnswerString:String?
    var answerOneLabel:String?
    var answerTwoLabel:String?
    var answerThreeLabel:String?
    var questionLabel:String = ""
    
    
    
    
    init(){
        coreDataService = CoreDataService.sharedCoreDataService
        context = coreDataService.mainQueueContext
        historyFetchRequest = NSFetchRequest(entityName: "VocaHistory")
        
        do{
            historyFetchedResults = try context.fetch(historyFetchRequest) as? [VocaHistory]
            //print(historyFetchedResults?.count)
            
            for result in historyFetchedResults!{
                //print(result.word?.english)
                let vocabularyFetchRequest = NSFetchRequest(entityName: "Vocabulary")
                let predicate = NSPredicate(format: "word = %@", result)
                vocabularyFetchRequest.predicate = predicate
                
                let vocabularyFetchedResults = try context.fetch(vocabularyFetchRequest) as! [Vocabulary]
                //print(vocabularyFetchedResults.count)
                questionArray.append(vocabularyFetchedResults[0])
            }
        }catch{
        }
        do{
            let fetchedRequest = NSFetchRequest(entityName: "Vocabulary")
            do{
                let fetchedResults = try context.fetch(fetchedRequest) as! [Vocabulary]
                for result in fetchedResults{
                    answerArray.append(result.chinese!)
                }
            }catch{
                
            }
        }
    }
    
    func getQuestionNum()->Int{
        var questionNum:Int = 0
        guard historyFetchedResults != nil else{
            return 0
        }
        
        questionNum = SettingService.sharedSettingService.getQuestionNum()
        if questionNum > getHistoryCount(){
            questionNum = getHistoryCount()
        }
        return questionNum
    }
    
    func getHistoryCount() -> Int{
        guard historyFetchedResults != nil else{
            return 0
        }
        return (historyFetchedResults?.count)!
    }
    
    func generateQuestion() -> String{
        randomIndex = Int.random(questionArray.count)
        correctAnswerInt = Int.random(3)
        //print("random question index is \(randomIndex!), correct index is \(correctAnswerInt!)")
        
        questionLabel = questionArray[randomIndex!].english!
        correctAnswerString = questionArray[randomIndex!].chinese
        
        
        return "Choose the correct definition for \(questionLabel.uppercased()): "
    }
    
    
    func getAnswerOne() -> String{
        if correctAnswerInt == 0{
            return correctAnswerString!
        }else{
            return generateAnswer()
        }
    }
    
    func getAnswerTwo() -> String{
        if correctAnswerInt == 1{
            return correctAnswerString!
        }else{
            return generateAnswer()
        }
    }
    
    func getAnswerThree() -> String{
        if correctAnswerInt == 2{
            return correctAnswerString!
        }else{
            return generateAnswer()
        }
    }
    
    func checkAnswer(_ answerIndex:Int) -> Bool{
        if answerIndex == correctAnswerInt{
            return true
        }else{
            return false
        }
    }
    
    func generateAnswer() -> String{
        let random = Int.random(answerArray.count)
        if answerArray[random] != correctAnswerString{
            return answerArray[random]
        }else{
            return generateAnswer()
        }
    }
    
    func getCorrectAnswerIndex() ->Int?{
        return correctAnswerInt!
    }
    
}
