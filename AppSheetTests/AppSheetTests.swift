//
//  AppSheetTests.swift
//  AppSheetTests
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import XCTest
@testable import AppSheet

class AppSheetTests: XCTestCase {

    func testUserListInitializationFromJSON() {
        let json = #"{"result":[1,2,3,4,5,6,7,8,9,10],"token":"a35b4"}"#.data(using: .utf8)!
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: json) as? [String: Any] else {
            XCTFail("Expected a valid Dictionary object from JSON")
            return
        }
        
        guard let userList = UserList(dictionary: dictionary) else {
            XCTFail("Expected a valid UserList object from Dictionary")
            return
        }
        
        XCTAssertEqual(userList.userIds, [1,2,3,4,5,6,7,8,9,10])
        XCTAssertEqual(userList.nextPageToken, "a35b4")
    }
    
    func testUserInitializationFromJSON() {
        let json = #"{"id":21,"name":"paul","age":48,"number":"555-555-5555","photo":"https://appsheettest1.azurewebsites.net/male-11.jpg","bio":"bio..."}"#.data(using: .utf8)!
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: json) as? [String: Any] else {
            XCTFail("Expected a valid Dictionary object from JSON")
            return
        }
        
        guard let user = User(dictionary: dictionary) else {
            XCTFail("Expected a valid User object from Dictionary")
            return
        }
        
        XCTAssertEqual(user.id, 21)
        XCTAssertEqual(user.name, "paul")
        XCTAssertEqual(user.age, 48)
        XCTAssertEqual(user.phone, "555-555-5555")
        XCTAssertEqual(user.photoURL, URL(string: "https://appsheettest1.azurewebsites.net/male-11.jpg"))
        XCTAssertEqual(user.bio, "bio...")
    }
    
    func testUserListDownload() {
        let expectation = XCTestExpectation(description: "Download user list")
        
        APIManager.fetchUserList(pageToken: nil) { (userList, error) in
            XCTAssertNotNil(userList, "Expected a valid UserList object")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUserDownload() {
        let expectation = XCTestExpectation(description: "Download user")
        
        APIManager.fetchUser(userId: 21) { (user, _) in
            XCTAssertNotNil(user, "Expected a valid User object")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUsersDownload() {
        let expectation = XCTestExpectation(description: "Download users")
        
        APIManager.fetchUsers(userIds: [1,2,3]) { (users, error) in
            XCTAssertNotNil(users, "Expected a valid User array object")
            XCTAssertEqual(users!.count, 3, "Expected 3 valid User objects")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAllUsersDownload() {
        let expectation = XCTestExpectation(description: "Download all users")
        
        let usersDownloader = UsersDownloader(completionHandler: { (users, error) in
            XCTAssertNotNil(users, "Expected a valid User array object")
            
            expectation.fulfill()
        })
        
        usersDownloader.fetchUsers()
        
        wait(for: [expectation], timeout: 15.0)
    }

}
