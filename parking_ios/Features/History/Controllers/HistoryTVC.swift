//
//  HistoryTVC.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/29/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

class HistoryTVC: UITableViewController {
    
    var viewModel: HistoryVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HistoryVM()
        self.title = "History"
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.register(HistoryTVCell.nib, forCellReuseIdentifier: HistoryTVCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel?.parkingHistory.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTVCell.identifier) as! HistoryTVCell
        cell.setup(self.viewModel!.parkingHistory[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { _,_ in
            self.viewModel!.delete(self.viewModel!.parkingHistory[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        return [delete]
    }
}
