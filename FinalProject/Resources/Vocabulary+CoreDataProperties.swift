//
//  Vocabulary+CoreDataProperties.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/29/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vocabulary {

    @NSManaged var chinese: String?
    @NSManaged var english: String?
    @NSManaged var example: String?
    @NSManaged var word: VocaHistory?

}
