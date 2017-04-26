//
//  NewsDetailViewController.swift
//  TinkoffTest
//
//  Created by Dmitriy Terekhin on 24/04/2017.
//  Copyright © 2017 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController,UINavigationControllerDelegate {
    
    let newsHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = lbl.font.withSize(20)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    let newsContentTextView: UITextView = {
        let txtVw = UITextView()
        txtVw.textColor = .black
        txtVw.isEditable = false
        txtVw.font = UIFont(name: ".SFUIText-Light", size: 18)
        txtVw.textAlignment = .left
        return txtVw
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.delegate = self
        view.addSubview(newsHeaderLabel)
        view.addSubview(newsContentTextView)
        workWithConstraints()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let tablVC = viewController as? NewsTableViewController {
            DispatchQueue.main.async {
                tablVC.newsTableViewRefreshControl.beginRefreshing()
                tablVC.newsTableViewRefreshControl.endRefreshing()
            }
        }
    }
    
    func workWithConstraints() {
        newsHeaderLabelConstraints()
        newsTextViewConstraints()
    }
    
    func newsHeaderLabelConstraints() {
        newsHeaderLabel.topAnchor.constraint(equalTo: newsHeaderLabel.superview!.topAnchor, constant: 80).isActive = true
        newsHeaderLabel.leftAnchor.constraint(equalTo: newsHeaderLabel.superview!.leftAnchor, constant: 20).isActive = true
        newsHeaderLabel.rightAnchor.constraint(equalTo: newsHeaderLabel.superview!.rightAnchor, constant: -20).isActive = true
        newsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func newsTextViewConstraints() {
        newsContentTextView.topAnchor.constraint(equalTo: newsHeaderLabel.bottomAnchor, constant: 20).isActive = true
        newsContentTextView.leftAnchor.constraint(equalTo: newsContentTextView.superview!.leftAnchor, constant: 30).isActive = true
        newsContentTextView.rightAnchor.constraint(equalTo: newsContentTextView.superview!.rightAnchor, constant: -30).isActive = true
        newsContentTextView.bottomAnchor.constraint(equalTo: newsContentTextView.superview!.bottomAnchor, constant: 50).isActive = true
        newsContentTextView.translatesAutoresizingMaskIntoConstraints = false
    }
}
