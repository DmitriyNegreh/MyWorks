//
//  ViewController.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var newsSource = [NewsModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var newsTableViewRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let leftButton = UIButton()
        leftButton.isEnabled = false
        leftButton.setImage(UIImage(named: "TinkoffBank1"), for: UIControlState.normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 35, height: 40)
        let barButton = UIBarButtonItem(customView: leftButton)
        leftButton.adjustsImageWhenHighlighted = false
        navigationItem.leftBarButtonItem = barButton
        title = "News"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsSource = CoreDataWorks.getNews()
        tableView.addSubview(newsTableViewRefreshControl)
        newsTableViewRefreshControl.addTarget(self, action: #selector(getNews), for: .valueChanged)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getNews()
    }
    
    func getNews() {
        newsTableViewRefreshControl.beginRefreshing()
        let url = URL(string: "https://api.tinkoff.ru/v1/news")
        if let newsURL = url {
            APIManager.loadNews(URL: newsURL) { [weak self] arrayOfNews, error in
                
                guard error == nil else {
                    let alert = UIAlertController(title: "Ошибка", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                        DispatchQueue.main.async {
                            self?.newsTableViewRefreshControl.endRefreshing()
                        }
                    }))
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
                
                if let newsVC = self {
                    if let news = arrayOfNews {
                        CoreDataWorks.saveNews(news)
                        newsVC.newsSource = newsVC.sortNewsByDate(CoreDataWorks.getNews())
                    }
                }
                DispatchQueue.main.async {
                    self?.newsTableViewRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    func sortNewsByDate(_ newsSource:[NewsModel]) -> [NewsModel] {
        let sortedArray = newsSource.sorted{$0.publicationDate > $1.publicationDate}
        return sortedArray
    }
    
    //MARK: - TableView data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsDetailVC = NewsDetailViewController()
        newsDetailVC.newsHeaderLabel.text = newsSource[indexPath.row].header
        newsDetailVC.newsContentTextView.text = newsSource[indexPath.row].content
        navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = newsSource[indexPath.row].header
    }
}

