//
//  APIClientManager.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import UIKit
import Alamofire

enum APIError: Error {
    case unknown
    case missingData
    case serialization
}

class APIManager {
    
    // MARK: - Properties
    
    private static let baseURL = URL(string: "https://appsheettest1.azurewebsites.net/sample/")!
   
    // MARK: - URLs

    private static func userDetailURL(_ userId: Int) -> URL {
        return APIManager.baseURL.appendingPathComponent("detail").appendingPathComponent(String(userId))
    }
    
    private static func userListURL(pageToken: String? = nil) -> URL {
        let url = APIManager.baseURL.appendingPathComponent("list")
        
        if let pageToken = pageToken, !pageToken.isEmpty {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = [URLQueryItem(name: "token", value: pageToken)]
            return urlComponents.url!
        }
        
        return url
    }
    
    // MARK: - Endpoints
    
    static func fetchUserList(pageToken: String?, completion: @escaping (UserList?, Error?) -> Void) {
        let url = userListURL(pageToken: pageToken)
        
        print("Downloading users list" + (pageToken != nil ? " with page token: \(pageToken!)" : ""))
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                guard let json = response.result.value as? [String: Any] else {
                    completion(nil, APIError.missingData)
                    return
                }
                
                guard let userList = UserList(dictionary: json) else {
                    completion(nil, APIError.serialization)
                    return
                }
                
                completion(userList, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    static func fetchUser(userId: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = userDetailURL(userId)
        
        print("Downloading user with ID: \(userId)")

        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                guard let json = response.result.value as? [String: Any] else {
                    completion(nil, APIError.missingData)
                    return
                }
                
                guard let user = User(dictionary: json) else {
                    completion(nil, APIError.serialization)
                    return
                }
                
                completion(user, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func fetchUsers(userIds: [Int], completion: @escaping ([User]?, [Error]?) -> Void) {
        guard !userIds.isEmpty else {
            completion([], nil)
            return
        }
        
        var users = [User]()
        var errors = [Error]()

        let dispatchGroup = DispatchGroup()
        
        userIds.forEach { (userId) in
            dispatchGroup.enter()
            
            fetchUser(userId: userId, completion: { (user, error) in
                if let user = user {
                    users.append(user)
                } else {
                    print("Error fetching user with id \(userId): \(error?.localizedDescription ?? "unknown")")
                    errors.append(error ?? APIError.unknown)
                }
                
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(users, errors)
        }
    }

}
