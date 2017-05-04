//
//  CoreDataWorks.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 25/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit
import CoreData

@objc(News)
public final class News: NSManagedObject {
    
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var header: String
    @NSManaged public private(set) var content: String
    @NSManaged public private(set) var publicationDate: Date
    
    internal static func insertIntoContext(moc: NSManagedObjectContext, newsModel: NewsModel) -> News {
        let news: News = moc.insertObject() as News
        news.id = newsModel.id
        news.header = newsModel.header
        news.content = newsModel.content
        news.publicationDate = newsModel.publicationDate
        return news
    }
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    public static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension News: ManagedObjectType {
    public static var entityName: String {
        return "News"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "publicationDate", ascending: false)]
    }
}

extension NSManagedObjectContext {
    public func insertObject<A: NSManagedObject>() -> A where A: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
