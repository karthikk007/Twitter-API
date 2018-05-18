//
//  TableViewModel.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 11/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation
import CoreLocation

protocol TableViewModelDelegate {
    func refresh()
    func handleError()
}

protocol TableViewModelDataSource {
    func numberOfItems(for section: Int) -> Int
    func title(for indexPath: IndexPath) -> String
    func subTitle(for indexPath: IndexPath) -> String
    func fetchData()
}

class TableViewModel: NSObject {
    
    fileprivate var location: CLLocation?
    
    var trends: [TwitterTrends] {
        didSet {
            delegate?.refresh()
        }
    }
    
    var delegate: TableViewModelDelegate? 
    
    override init() {
        trends = [TwitterTrends]()
        delegate = nil
        location = nil
        super.init()
        
        LocationManager.shared.updateDelegate(delegate: self)
    }
    
    private func fetch(woeid: Int) {
        TwitterAPIDownloader.shared.fetchTrends(for: woeid, decode: [TwitterTrends].self) { [self] (result, error) in
            if let result = result, error == .success {
                self.trends = result
            } else {
                self.delegate?.handleError()
            }
        }
    }
}

extension TableViewModel: TableViewModelDataSource {

    func numberOfItems(for section: Int) -> Int {
        return trends.count
    }
    
    func title(for indexPath: IndexPath) -> String {
        return "Name: " + trends[indexPath.row].name
    }
    
    func subTitle(for indexPath: IndexPath) -> String {
        var volume: String = "<Not Available>"
        if let vol = trends[indexPath.row].tweetVolume {
            volume = String(vol)
        }
        return "Tweet Volume: " + volume
    }
    
    func fetchData() {
        LocationManager.shared.getCurrentLocation()
    }
    
    func downloadData(for location: CLLocation) {
        TwitterAPIDownloader.shared.getWoeid(location: location) { (woeid, error) in
            if error == TwitterAPIError.failure {
                print("failed woeid")
                self.delegate?.handleError()
            } else {
                self.fetch(woeid: woeid)
            }
        }
    }
}

extension TableViewModel: LocationUpdate {
    func locationUpdated(location: CLLocation) {
        print("updated \(location)")
        downloadData(for: location)
    }
}
