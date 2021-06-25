//
//  String+Extension.swift
//  TSUserNotifications
//
//  Created by TAE SU LEE on 2021/06/25.
//

import Foundation

extension String {
    private struct Formatter {
        static let dateString: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar.current
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    var date: Date? {
        Formatter.dateString.date(from: self)
    }
}
