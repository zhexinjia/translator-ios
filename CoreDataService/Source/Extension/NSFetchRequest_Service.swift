//
//  NSFetchRequest_Service.swift
//
//  Created by Charles Augustine.
//  Copyright (c) 2015 Charles Augustine. All rights reserved.
//


import CoreData
import Foundation


public extension NSFetchRequest {
	public convenience init<T:NSManagedObject>(namedEntity: T.Type) where T:NamedEntity {
		self.init(entityName: namedEntity.entityName)
	}
}
