//
//  UserTableViewController.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewController: UITableViewController {

    // MARK: - Properties

    private static let userPhotoPlaceholderImage = UIImage(named: "user_profile_placeholder")!

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!

    var user: User?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.size.width / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
    }
    
    // MARK: - Class Methods

    private func configureView() {
        clearView()
        
        guard let user = user else {
            return
        }
        
        if let photoURL = user.photoURL {
            userPhotoImageView.sd_setImage(with: photoURL, placeholderImage: UserTableViewController.userPhotoPlaceholderImage)
        }
        
        if let name = user.name {
            let capitalized = name.capitalized
            
            self.title = capitalized
            userNameLabel.text = capitalized
        }
        
        if let age = user.age {
            userAgeLabel.text = String(age)
        }
        
        if let phone = user.phone {
            userPhoneLabel.text = PhoneNumberFormatter.shared.format(phone: phone)
        }
        
        if let bio = user.bio {
            userBioLabel.text = bio
        }
    }
    
    private func clearView() {
        self.title = NSLocalizedString("User", comment: "User details screen title")
        
        userPhotoImageView.image = UserTableViewController.userPhotoPlaceholderImage
        userAgeLabel.text = nil
        userNameLabel.text = nil
        userPhoneLabel.text = nil
        userBioLabel.text = nil
    }
    
}
