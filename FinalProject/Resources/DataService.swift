//
//  DataService.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/29/16.
//
//

import Foundation
import CoreData
import CoreDataService

class DataService{
    
    static let sharedDataService = DataService()
    let coreDataService:CoreDataService?
    let context:NSManagedObjectContext?
    var autoAdding:Bool?
    
    private init(){
        coreDataService = CoreDataService.sharedCoreDataService
        context = coreDataService?.mainQueueContext
        
        //get autoAdding from database, fix later!!!!!!!!!!!!!!!!!
        autoAdding = true
    }
    
    
    
    //get the Chinese definition
    func getDefination(vocabulary:String) -> String{
        let word = vocabulary.lowercaseString
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchRequest.predicate = predicate
        let count = context?.countForFetchRequest(fetchRequest, error: nil)
        
        guard count != NSNotFound else{
            fatalError("Can not get \(word) in database")
        }
        if count == 0{
            //print("getting definition from web")
            if SaveDataFromWeb(word) == false{
                return "No such vocabulary found\nplease check your spelling or\nTry Wikipidea tab for English Definition"
            }
        }else{
            //print("getting definition from database")
        }
        
        var definition:String = ""
        do{
            let fetchedResult = try context?.executeFetchRequest(fetchRequest) as! [Vocabulary]
            for item in fetchedResult{
                definition += item.chinese!
            }
        }catch{
                
        }
        return definition
        
    }
    
    func getScentence(vocabulary:String) ->String{
        let word = vocabulary.lowercaseString
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchRequest.predicate = predicate
        let count = context?.countForFetchRequest(fetchRequest, error: nil)
        
        guard count != NSNotFound else{
            fatalError("Can not get \(word) in database")
        }
        
        if count == 0{
            //save definition from web to database
            if SaveDataFromWeb(word) == false{
                return "No such vocabulary found\nPlease check your spelling or\nTry Wikipidea tab for English Definition"
            }
        }
        
        var example:String = ""
        do{
            let fetchedResult = try context?.executeFetchRequest(fetchRequest) as! [Vocabulary]
            for item in fetchedResult{
                example += item.example!
            }
        }catch{
                
        }
        return example
    }
    
    func SaveDataFromWeb(word:String) -> Bool{
        let definition = getDefinitionFromWeb(word)
        let example = getScentenceFromWeb(word)
        guard definition != "" else{
            //print("before return false")
            return false
        }
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: context!) as! Vocabulary
        entity.english = word
        entity.chinese = definition
        entity.example = example
        
        try! context?.save()
        coreDataService?.saveRootContext({
            //Intentionally left blank
        })
        return true
    }
    
    func saveWordToHistory(vocabulary:String) -> Bool{
        let word = vocabulary.lowercaseString
        let fetchHistory = NSFetchRequest(entityName: "VocaHistory")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchHistory.predicate = predicate
        let count = context?.countForFetchRequest(fetchHistory, error: nil)
        
        //make sure this vocabulary is not in history, so count == 0
        guard count != NSNotFound && count == 0 else{
            return false
        }
        
        //save word to VocaHistory and update Vocabulary's relationship
        let historyEntity = NSEntityDescription.insertNewObjectForEntityForName("VocaHistory", inManagedObjectContext: context!) as! VocaHistory
        
        
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        
        fetchRequest.predicate = predicate
        
        do{
            let fetchedResult = try context?.executeFetchRequest(fetchRequest) as! [Vocabulary]
            let vocabularyEntity = fetchedResult[0]
            vocabularyEntity.setValue(historyEntity, forKey: "word")
            historyEntity.english = word
            historyEntity.setValue(vocabularyEntity, forKey: "word")
            try! context?.save()
            coreDataService?.saveRootContext({
                //Intentionally left blank
            })
        }catch{
            
        }
        return true
    }
    
    
    
    
    
    func getDefinitionFromWeb(word:String) ->String{
        var result:String = ""
        
        let preURL = "http://www.youdao.com/w/eng/"
        let URL = preURL+word
        let data = NSData(contentsOfURL: NSURL(string: URL)!)
        let doc = TFHpple(HTMLData: data)
        let searchString = "//div[@class='trans-wrapper clearfix']/div[@class='trans-container']/ul/li"
        if let elements = doc.searchWithXPathQuery(searchString) as? [TFHppleElement]{
            //print("counter \(elements.count)")
            for element in elements{
                result += element.content + "\n"
            }
        }
        
        return result
    }
    
    
    
    //get the example how to use the vocabulary
    func getScentenceFromWeb(word:String) -> String{
        var result:String = ""
        
        let prefixURL = "http://m.youdao.com/singledict?q="
        let surfixURL = "&le=eng&dict=blng_sents&more=true"
        let URL = prefixURL + word + surfixURL
        let data = NSData(contentsOfURL: NSURL(string: URL)!)
        let doc = TFHpple(HTMLData: data)
        
        let searchString = "//div[@class=\"col2\"]/p"
        if let elements = doc.searchWithXPathQuery(searchString) as? [TFHppleElement]{
            for element in elements{
                result += element.content + "\n"
            }
        }
        return result
    }
}
