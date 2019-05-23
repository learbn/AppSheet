//
//  PhoneNumberFormatter.swift
//  AppSheet
//
//  Created by Lea Tsirulnikov on 05/20/2019.
//  Copyright © 2019 Lea Tsirulnikov. All rights reserved.
//

import Foundation
import PhoneNumberKit

class PhoneNumberFormatter {
    
    static let shared = PhoneNumberFormatter()
    
    static let defaultCountryCode = "US"
    
    private let phoneNumberKit = PhoneNumberKit()
    
    func isValid(phone: String, countryCode: String = defaultCountryCode) -> Bool {
        return phoneNumber(phone: phone, countryCode: countryCode) != nil
    }
    
    func format(phone: String, countryCode: String = defaultCountryCode) -> String? {
        guard let phoneNumber = phoneNumber(phone: phone, countryCode: countryCode) else { return nil }
        
        return phoneNumberKit.format(phoneNumber, toType: .national, withPrefix: false)
    }
    
    private func phoneNumber(phone: String, countryCode: String = defaultCountryCode) -> PhoneNumber? {
        return try? phoneNumberKit.parse(phone, withRegion: countryCode, ignoreType: true)
    }
    
}
