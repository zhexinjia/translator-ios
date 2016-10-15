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
    
    fileprivate init(){
        coreDataService = CoreDataService.sharedCoreDataService
        context = coreDataService?.mainQueueContext
        
        //get autoAdding from database, fix later!!!!!!!!!!!!!!!!!
        autoAdding = true
    }
    
    
    
    //get the Chinese definition
    func getDefination(_ vocabulary:String) -> String{
        let word = vocabulary.lowercased()
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchRequest.predicate = predicate
        let count = context?.count(for: fetchRequest, error: nil)
        
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
            let fetchedResult = try context?.fetch(fetchRequest) as! [Vocabulary]
            for item in fetchedResult{
                definition += item.chinese!
            }
        }catch{
                
        }
        return definition
        
    }
    
    func getScentence(_ vocabulary:String) ->String{
        let word = vocabulary.lowercased()
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchRequest.predicate = predicate
        let count = context?.count(for: fetchRequest, error: nil)
        
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
            let fetchedResult = try context?.fetch(fetchRequest) as! [Vocabulary]
            for item in fetchedResult{
                example += item.example!
            }
        }catch{
                
        }
        return example
    }
    
    func SaveDataFromWeb(_ word:String) -> Bool{
        let definition = getDefinitionFromWeb(word)
        let example = getScentenceFromWeb(word)
        guard definition != "" else{
            //print("before return false")
            return false
        }
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Vocabulary", into: context!) as! Vocabulary
        entity.english = word
        entity.chinese = definition
        entity.example = example
        
        try! context?.save()
        coreDataService?.saveRootContext({
            //Intentionally left blank
        })
        return true
    }
    
    func saveWordToHistory(_ vocabulary:String) -> Bool{
        let word = vocabulary.lowercased()
        let fetchHistory = NSFetchRequest(entityName: "VocaHistory")
        let predicate = NSPredicate(format: "english = %@", word)
        fetchHistory.predicate = predicate
        let count = context?.count(for: fetchHistory, error: nil)
        
        //make sure this vocabulary is not in history, so count == 0
        guard count != NSNotFound && count == 0 else{
            return false
        }
        
        //save word to VocaHistory and update Vocabulary's relationship
        let historyEntity = NSEntityDescription.insertNewObject(forEntityName: "VocaHistory", into: context!) as! VocaHistory
        
        
        let fetchRequest = NSFetchRequest(entityName: "Vocabulary")
        
        fetchRequest.predicate = predicate
        
        do{
            let fetchedResult = try context?.fetch(fetchRequest) as! [Vocabulary]
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
    
    
    
    
    
    func getDefinitionFromWeb(_ word:String) ->String{
        var result:String = ""
        
        let preURL = "http://www.youdao.com/w/eng/"
        let URL = preURL+word
        let data = try? Data(contentsOf: Foundation.URL(string: URL)!)
        let doc = TFHpple(htmlData: data)
        let searchString = "//div[@class='trans-wrapper clearfix']/div[@class='trans-container']/ul/li"
        if let elements = doc?.search(withXPathQuery: searchString) as? [TFHppleElement]{
            //print("counter \(elements.count)")
            for element in elements{
                result += element.content + "\n"
            }
        }
        
        return result
    }
    
    
    
    //get the example how to use the vocabulary
    func getScentenceFromWeb(_ word:String) -> String{
        var result:String = ""
        
        let prefixURL = "http://m.youdao.com/singledict?q="
        let surfixURL = "&le=eng&dict=blng_sents&more=true"
        let URL = prefixURL + word + surfixURL
        let data = try? Data(contentsOf: Foundation.URL(string: URL)!)
        let doc = TFHpple(htmlData: data)
        
        let searchString = "//div[@class=\"col2\"]/p"
        if let elements = doc?.search(withXPathQuery: searchString) as? [TFHppleElement]{
            for element in elements{
                result += element.content + "\n"
            }
        }
        return result
    }
}
