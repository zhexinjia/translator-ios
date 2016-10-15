//
//  Setting+CoreDataProperties.swift
//  FinalProject
//
//  Created by Zhexin Jia on 8/2/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Setting {

    @NSManaged var autoAdd: NSNumber?
    @NSManaged var keyboardAutoPop: NSNumber?
    @NSManaged var questionNum: NSNumber?

}
