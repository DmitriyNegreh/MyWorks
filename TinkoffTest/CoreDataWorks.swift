//
//  CoreDataWorks.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 25/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataWorks {
    
    class func saveNews(_ inputNewsArray: [NewsModel]) {
        guard inputNewsArray.isEmpty == false else {return}
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.perform {
            do {
                let newsEntityArray = try context.fetch(News.fetchRequest()) as! [News]
                
                for news in inputNewsArray {
                    if newsEntityArray.contains(where:{ $0.id == news.id}) {} else {
                        let newNewsEntity = NSEntityDescription.insertNewObject(forEntityName: "News", into: context) as! News
                        newNewsEntity.header = news.header
                        newNewsEntity.id = news.id
                        newNewsEntity.publicationDate = Int64(news.publicationDate)
                        newNewsEntity.content = news.content
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }
            } catch {
                fatalError("Failed to fetch theme: \(error)")
            }
        }
    }
    
    class func getNews() -> [NewsModel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var news = [NewsModel]()
        
        context.performAndWait {
            do {
                let newsEntityArray = try context.fetch(News.fetchRequest()) as! [News]
                guard newsEntityArray.count != 0 else {return }
                for newsEntity in newsEntityArray {
                    news.append(NewsModel(id: newsEntity.id!,
                                          header: newsEntity.header!,
                                          content: newsEntity.content!,
                                          publicationDate: Int(newsEntity.publicationDate)))
                }
                
            } catch {
                print("Error with request: \(error)")
            }
        }
            return news
    }
}
