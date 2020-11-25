//
//  DateExtention.swift
//  Where_Am_I
//
//  Created by Arundeep Singh on 2020/11/21.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import Foundation

extension Date {
    func string(withFormat format:String = "YYYY/MM/dd, HH:mm") -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
