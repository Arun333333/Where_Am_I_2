//
//  AddressManager.swift
//  Where_Am_I
//
//  Created by Arundeep Singh on 2020/11/21.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import CoreLocation
import Contacts

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}


extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}

extension CLPlacemark {
    var mailingAddress: String? {
        return postalAddress?.mailingAddress
    }
}

extension CNPostalAddress {
    var mailingAddress: String {
        return Formatter.mailingAddress.string(from: self)
    }
}
