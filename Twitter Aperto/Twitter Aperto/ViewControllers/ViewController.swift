//
//  ViewController.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 10/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController {
    
    var dataSource: TableViewModelDataSource! = nil
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = UIColor.blue
        ai.sizeThatFits(CGSize(width: 100, height: 100))
        return ai
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        dataSource = ViewModelFactory.getTableViewViewModel(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Twitter Trending Topis"
        tableView.tableFooterView = UIView()
        
        dataSource.fetchData()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            cell.selectionStyle = .none
        }
        
        cell.textLabel?.text = dataSource.title(for: indexPath)
        cell.detailTextLabel?.text = dataSource.subTitle(for: indexPath)
        
        return cell
    }
}

extension ViewController: TableViewModelDelegate {
    func refresh() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func handleError() {
        let alert = UIAlertController(title: "Error", message: "Unable to fetch data", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Retry", style: .default) { (alertAction) in
            self.dataSource.fetchData()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
