//
//  UserTableViewCell.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {

    // MARK: - Properties

    private static let userPhotoPlaceholderImage = UIImage(named: "user_profile_placeholder")!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!

    var user: User? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.size.width / 2.0 // Circle
        
        clearView()
    }

    // MARK: - Class Methods

    private func configureView() {
        clearView()

        guard let user = user else {
            return
        }
        
        if let name = user.name {
            userNameLabel.text = name.capitalized
        }
        
        if let phone = user.phone {
            userPhoneLabel.text = PhoneNumberFormatter.shared.format(phone: phone)
        }
        
        if let photoURL = user.photoURL {
            userPhotoImageView.sd_setImage(with: photoURL, placeholderImage: UserTableViewCell.userPhotoPlaceholderImage)
        }
    }
    
    private func clearView() {
        userNameLabel.text = nil
        userPhoneLabel.text = nil
        userPhotoImageView.image = UserTableViewCell.userPhotoPlaceholderImage
    }

}
