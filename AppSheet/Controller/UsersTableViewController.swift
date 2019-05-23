//
//  UsersTableViewController.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    // MARK: - Properties

    private static let numberOfUsersToDisplay = 5
    
    private var usersDownloader: UsersDownloader?
    private var users = [User]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRefreshControl()
        
        // Start initial users download
        refreshControl?.beginRefreshing()
        handleRefreshControl()
    }

    // MARK: - Class Methods

    private func configureRefreshControl () {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetchAndShowUsers()
    }
    
    private func fetchAndShowUsers() {
        refreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("Loading Users...", comment: "Refresh control loading users title"))

        usersDownloader = UsersDownloader(completionHandler: { [weak self] (users, error) in
            guard let `self` = self else { return }

            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = nil
            
            guard let users = users else {
                print("Error downloading users: \(error?.localizedDescription ?? "Unknown")")
                
                self.users = []
                self.tableView.reloadData()
                return
            }
            
            let allUsersDescription = users.sorted { $0.id < $1.id }.map { $0.description }.joined(separator: "\n")
            print("Fetched users:\n\(allUsersDescription)")
            
            self.users = UsersTableViewController.filterAndSort(users: users)
            self.tableView.reloadData()
        })
        
        usersDownloader?.fetchUsers()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellIdentifier", for: indexPath) as! UserTableViewCell

        cell.user = users[indexPath.row]
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailsViewController = segue.destination as? UserTableViewController {
            guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPathForSelectedRow.row]
            userDetailsViewController.user = user
        }
    }
    
    // MARK: - Helper

    private static func filterAndSort(users: [User]) -> [User] {
        guard !users.isEmpty else {
            return []
        }
        
        // Filter out users with no age or phone
        var users = users.filter({ (user) -> Bool in
            guard user.age != nil else { return false }
            
            guard let phone = user.phone else { return false }
            return PhoneNumberFormatter.shared.isValid(phone: phone)
        })
        
        // Sort by age
        users.sort { $0.age! < $1.age! }
        
        // Keep first n users
        users = Array(users.prefix(numberOfUsersToDisplay))
        
        // Sort by name
        users.sort { $0.name ?? "" < $1.name ?? "" }
        
        return users
    }
    
}
