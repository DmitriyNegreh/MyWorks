//
//  NewsTableViewCell.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 02/05/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    func configure(for news: News) {
        self.textLabel?.text = news.header
    }
}
