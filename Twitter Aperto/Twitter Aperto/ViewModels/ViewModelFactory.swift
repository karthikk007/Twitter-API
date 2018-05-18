//
//  ViewModelFactory.swift
//  Twitter Aperto
//
//  Created by Karthik Kumar on 11/05/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

class ViewModelFactory {
    static func getTableViewViewModel(delegate: TableViewModelDelegate) -> TableViewModelDataSource {
        let dataSource = TableViewModel()
        dataSource.delegate = delegate
        return dataSource as TableViewModelDataSource
    }
}
