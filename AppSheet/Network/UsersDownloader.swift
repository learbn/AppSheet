//
//  UsersDownloader.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import Foundation

class UsersDownloader {
    
    typealias CompletionHandler = (([User]?, Error?) -> Void)
    
    let completionHandler: CompletionHandler
    
    private var users = [User]()
    
    init(completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
    }
    
    func fetchUsers() {
        fetchUsers(pageToken: nil)
    }
    
    private func fetchUsers(pageToken: String?) {
        APIManager.fetchUserList(pageToken: pageToken) { (userList, error) in
            guard let userList = userList, !userList.userIds.isEmpty else {
                self.completionHandler(nil, error ?? APIError.unknown)
                return
            }
            
            APIManager.fetchUsers(userIds: userList.userIds, completion: { (users, errors) in
                guard let users = users else {
                    self.completionHandler(nil, errors?.first ?? APIError.unknown)
                    return
                }
                
                self.users.append(contentsOf: users)
                
                if let nextPageToken = userList.nextPageToken {
                    self.fetchUsers(pageToken: nextPageToken)
                } else {
                    self.completionHandler(self.users, nil)
                }
            })
        }
    }
    
}
