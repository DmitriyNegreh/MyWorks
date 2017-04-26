//
//  APIManager.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class APIManager {
    class func loadNews(URL: URL, complectionHandler: @escaping ([NewsModel]?, Error?)->()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let task = session.dataTask(with: request) { data, response, error in
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                guard let data = data else {return}
                APIResponseParser.parseNews(data: data,complectionHandler: complectionHandler)
            } else {
                print("Failure: %@", error?.localizedDescription as Any)
                complectionHandler(nil, error)
            }
        }
        task.resume()
    }
}
