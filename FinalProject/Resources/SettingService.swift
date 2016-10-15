//
//  SettingService.swift
//  FinalProject
//
//  Created by Zhexin Jia on 8/1/16.
//
//

import Foundation
import CoreData
import CoreDataService

//FIX the error When DATA History has no data, add if

class SettingService{
    static let sharedSettingService = SettingService()
    let coreDataService:CoreDataService
    let context:NSManagedObjectContext
    
    let fetchRequest:NSFetchRequest<AnyObject>
    
    fileprivate init(){
        coreDataService = CoreDataService.sharedCoreDataService
        context = coreDataService.mainQueueContext
        fetchRequest = NSFetchRequest(entityName: "Setting")
    }
    
    func setAutoAdd(_ boolValue:Bool){
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            if fetchedResult!.count == 0{
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: context) as! Setting
                entity.autoAdd = boolValue as NSNumber?
                entity.keyboardAutoPop = false
                entity.questionNum = 10
                try! context.save()
                coreDataService.saveRootContext({
                    //Intentionally left blank
                })
            }else{
                fetchedResult![0].setValue(boolValue, forKey: "autoAdd")
                try! context.save()
                coreDataService.saveRootContext({
                    //Intentionally left blank
                })
            }
        }catch{
        }
    }
    
    func getAutoAdd() -> Bool{
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            
            if let result = fetchedResult{
                if result.count != 0{
                    return ((result[0].autoAdd) as! Bool)
                }
            }
        }catch{
        }
        return true
    }
    
    func setQuestionNum(_ questionNum:Int){
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            if let result = fetchedResult{
                //print(String(result.count))
                //if let result = fetchedResult{
                    //print(String(result.count))
                    if result.count == 0{
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: context) as! Setting
                        entity.questionNum = questionNum as NSNumber?
                        entity.autoAdd = true
                        entity.keyboardAutoPop = false
                        try! context.save()
                        coreDataService.saveRootContext({
                            //Intentionally left blank
                        })
                    }else{
                        result[0].setValue(questionNum, forKey: "questionNum")
                        try! context.save()
                        coreDataService.saveRootContext({
                            //Intentionally left blank
                        })
                    }
                //}
            }
        }catch{
        }
    }
    
    
    func getQuestionNum() -> Int{
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            if let result = fetchedResult{
                if result.count != 0{
                    return (result[0].questionNum as! Int)
                }
            }
        }catch{
        }
        return 10
    }
    
    func setAutoPopUpKeyboard(_ boolValue: Bool){
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            if let result = fetchedResult{
                //print(String(result.count))
                if result.count == 0{
                    let entity = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: context) as! Setting
                    entity.keyboardAutoPop = boolValue as NSNumber?
                    entity.autoAdd = true
                    entity.questionNum = 10
                    try! context.save()
                    coreDataService.saveRootContext({
                        //Intentionally left blank
                    })
                }else{
                    result[0].setValue(boolValue, forKey: "keyboardAutoPop")
                    try! context.save()
                    coreDataService.saveRootContext({
                        //Intentionally left blank
                    })
                }
            }
        }catch{
        }
    }
    
    func getAutoPopUPKeyboard() -> Bool{
        do{
            let fetchedResult = try context.fetch(fetchRequest) as? [Setting]
            if let result = fetchedResult{
                if result.count != 0{
                    return (result[0].keyboardAutoPop as! Bool)
                }
            }
        }catch{
        }
        return false
    }
    
}
