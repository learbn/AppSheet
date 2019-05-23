//
//  UserList.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import Foundation

class UserList {
    
    private struct JSONKeys {
        static let result = "result"
        static let nextPageToken = "token"
    }
    
    let userIds: [Int]
    let nextPageToken: String?

    init?(dictionary: [String: Any]) {
        guard let userIds = dictionary[JSONKeys.result] as? [Int] else { return nil }
        self.userIds = userIds
        
        self.nextPageToken = dictionary[JSONKeys.nextPageToken] as? String
    }
    
}

extension UserList: CustomStringConvertible {
    var description: String {
        // Outputs: "User list: [1, 2, 3], next page token: b32b3"
        var string = "User list: \(userIds.debugDescription)"
        
        if let nextPageToken = nextPageToken, !nextPageToken.isEmpty {
            string += ", next page token: \(nextPageToken)"
        }
        
        return string
    }
}
