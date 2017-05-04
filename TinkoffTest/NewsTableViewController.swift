//
//  ViewController.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewController: UITableViewController, ManagedObjectContextSettable,NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var newsSource = [News]()
    
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
        tableView.addSubview(newsTableViewRefreshControl)
        newsTableViewRefreshControl.addTarget(self, action: #selector(getNews), for: .valueChanged)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        getNews()
    }
    
    @objc private func getNews() {
        newsTableViewRefreshControl.beginRefreshing()
        APIManager.loadNews() { [weak self] arrayOfNews, error in
            
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
            self?.insertDataInCD(arrayOfNews)
        }
    }
    
    private func insertDataInCD(_ arrayOfNews: [NewsModel]?) {
        
        let objectsOnDisc = fetchObject()
        
        if let news = arrayOfNews {
            for nw in news {
                if objectsOnDisc.contains(where: { $0.id == nw.id}) {} else {
                    managedObjectContext.performChanges {
                        _ = News.insertIntoContext(moc: self.managedObjectContext, newsModel: nw)
                    }
                }
            }
        }
        setupTableView()
    }
    
    private func setupTableView() {
        newsSource = fetchObject()
        DispatchQueue.main.async {
            self.newsTableViewRefreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func fetchObject() -> [News] {
        let request = News.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        return  fetchedResultsController.fetchedObjects as? [News] ?? [News]()
    }
    
    //MARK: - TableView data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsTableViewCell
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
        if let newsCell = cell as? NewsTableViewCell {
            newsCell.configure(for: newsSource[indexPath.row])
        }
    }
}
