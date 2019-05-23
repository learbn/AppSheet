//
//  User.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import UIKit

class User {
    
    private struct JSONKeys {
        static let id = "id"
        static let name = "name"
        static let age = "age"
        static let phone = "number"
        static let photoURL = "photo"
        static let bio = "bio"
    }

    let id: Int
    let name: String?
    let age: Int?
    let phone: String?
    let photoURL: URL?
    let bio: String?
    
    init?(dictionary: [String: Any]) {
        guard let userId = dictionary[JSONKeys.id] as? Int else { return nil }
        self.id = userId
        
        self.name = dictionary[JSONKeys.name] as? String
        self.age = dictionary[JSONKeys.age] as? Int
        self.phone = dictionary[JSONKeys.phone] as? String

        if let photoURLString = dictionary[JSONKeys.photoURL] as? String,
            let photoURL = URL(string: photoURLString) {
            self.photoURL = photoURL
        } else {
            self.photoURL = nil
        }
        
        self.bio = dictionary[JSONKeys.bio] as? String
    }
    
}

extension User: CustomStringConvertible {
    var description: String {
        // Outputs: "id: 21, name: paul, age: 48, phone: 555-555-5555"
        var string = "id: \(id)"
        
        if let name = name, !name.isEmpty {
            string += ", name: \(name)"
        }
        
        if let age = age {
            string += ", age: \(age)"
        }
        
        if let phone = phone, !phone.isEmpty {
            string += ", phone: \(phone)"
        }
        
        return string
    }
}
