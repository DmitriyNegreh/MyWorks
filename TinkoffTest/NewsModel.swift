//
//  NewsModel.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

struct NewsModel {
    var id: String
    var header: String
    var content: String
    var publicationDate: Date
    
    init(id: String, header: String, content: String, publicationDate: Date) {
        self.id = id
        self.header = header
        self.content = content
        self.publicationDate = publicationDate
    }
}
