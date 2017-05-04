//
//  APIResponseParser.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class APIResponseParser {
    class func parseNews(data: Data, complectionHandler: ([NewsModel]?, Error?)->()) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let newsArray = json["payload"] as? [[String : Any]] {
                    let news = newsArray.map { news -> NewsModel in
                        var currentNews = NewsModel(id: news["id"] as? String ?? "",
                                         header: news["name"] as? String ?? "",
                                         content: news["text"] as? String ?? "",
                                         publicationDate: Date())
                        if let pabDate = news["publicationDate"] as? [String:Any] {
                            let date = Date(timeIntervalSince1970: pabDate["milliseconds"] as? Double ?? 0)
                            currentNews.publicationDate = date
                        }
                        return currentNews
                    }
                    complectionHandler(news, nil)
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            complectionHandler(nil,error)
        }
    }
}
